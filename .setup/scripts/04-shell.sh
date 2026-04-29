#!/bin/bash
set -e

echo "=== Setting up Shell Configuration ==="

# Install Python packages
echo "Installing Python packages..."
echo "- Installing aider for AI-assisted coding"
if ! mise exec python -- python -m pip install -U aider-chat; then
    echo "Warning: Failed to install aider. Continuing..."
fi

# Cache kubectl completions for zsh
echo "Caching kubectl completions..."
mkdir -p "$HOME/.zsh/completions"
if command -v kubectl >/dev/null 2>&1; then
    kubectl completion zsh > "$HOME/.zsh/completions/_kubectl" 2>/dev/null || echo "Warning: Failed to cache kubectl completions. Continuing..."
fi

# Setup tmux configuration
echo "Setting up tmux..."

# Install tmux plugin manager
if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
    echo "- Installing tmux plugin manager..."
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
fi

# Install recommended tmux plugins
echo "- Note: To install tmux plugins after setup, press CTRL+A then SHIFT+I within a tmux session"

# Install nerd fonts
echo "Installing nerd fonts..."
if [[ "$OSTYPE" == "darwin"* ]]; then
    FONT_DIR="$HOME/Library/Fonts"
else
    FONT_DIR="$HOME/.local/share/fonts"
    mkdir -p "$FONT_DIR"
fi

if [ ! -f "$FONT_DIR/AnonymiceProNerdFontMono-Regular.ttf" ]; then
    echo "- Downloading Anonymous Pro Nerd Font..."
    curl -fLo "$FONT_DIR/AnonymiceProNerdFontMono-Regular.ttf" https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/AnonymousPro/Regular/AnonymiceProNerdFontMono-Regular.ttf

    # Refresh font cache on Linux
    if [[ "$OSTYPE" != "darwin"* ]]; then
        echo "- Refreshing font cache..."
        fc-cache -f -v
    fi

    echo "- Font installed. You may need to configure your terminal to use this font."
    echo "  Font name: AnonymiceProNerdFontMono-Regular"
fi

echo "Shell configuration complete!"
