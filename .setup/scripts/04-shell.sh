#!/bin/bash
set -e

echo "=== Setting up Shell Configuration ==="

# Create ~/.zshrc.local from the committed template (first run only)
echo "Checking local shell overrides..."
if [ ! -f "$HOME/.zshrc.local" ]; then
    if [ -f "$HOME/.zshrc.local.example" ]; then
        cp "$HOME/.zshrc.local.example" "$HOME/.zshrc.local"
        echo "- Created ~/.zshrc.local from template — add your values"
    else
        echo "Warning: ~/.zshrc.local.example not found (stow not run yet?). Continuing..."
    fi
fi

# Cache kubectl completions for zsh
echo "Caching kubectl completions..."
mkdir -p "$HOME/.zsh/completions"
if command -v kubectl >/dev/null 2>&1; then
    kubectl completion zsh > "$HOME/.zsh/completions/_kubectl" 2>/dev/null || echo "Warning: Failed to cache kubectl completions. Continuing..."
fi

# tmux is optional now that herdr is the daily driver, so its plugin manager
# only bootstraps when tmux was actually selected.
if command -v tmux &> /dev/null; then
    echo "Setting up tmux..."

    if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
        echo "- Installing tmux plugin manager..."
        git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm \
            || echo "Warning: tpm clone failed. Continuing..."
    fi

    echo "- Note: press CTRL+A then SHIFT+I inside tmux to install its plugins"
fi

# Omarchy logs in to bash, so offer zsh as the login shell: without this
# none of the zsh config ever loads. chsh asks for the user's password, and
# a yes takes effect at the next login.
zsh_path=$(command -v zsh || true)
if [ -n "$zsh_path" ] && [ "$SHELL" != "$zsh_path" ]; then
    read -p "Change login shell to zsh? (y/n) " change_shell
    if [[ "$change_shell" =~ ^[Yy]$ ]]; then
        if chsh -s "$zsh_path"; then
            echo "- Login shell set to zsh; it takes effect at the next login"
        else
            echo "Warning: chsh failed; re-run this stage to try again. Continuing..."
        fi
    fi
fi

echo "Shell configuration complete!"
