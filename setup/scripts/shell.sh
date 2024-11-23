#!/bin/bash
set -e

echo "=== Setting up Shell Configuration ==="

# Install colorls for enhanced directory listings
echo "Installing colorls..."
mise exec ruby -- gem install colorls

# Install aider for AI-assisted coding
echo "Installing aider..."
mise exec python -- python -m pip install -U aider-chat


# Install oh-my-zsh if not already installed
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "Installing oh-my-zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

# Install spaceship prompt
if [ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/spaceship-prompt" ]; then
    echo "Installing spaceship prompt..."
    git clone https://github.com/spaceship-prompt/spaceship-prompt.git "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/spaceship-prompt" --depth=1
    ln -sf "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/spaceship-prompt/spaceship.zsh-theme" "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/spaceship.zsh-theme"
fi

# Install zsh-syntax-highlighting
if [ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting" ]; then
    echo "Installing zsh-syntax-highlighting..."
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
fi

# Install zsh-autosuggestions
if [ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions" ]; then
    echo "Installing zsh-autosuggestions..."
    git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
fi

# Setup tmux plugin manager
if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
    echo "Installing tmux plugin manager..."
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
fi

# Install nerd fonts
if [[ "$OSTYPE" == "darwin"* ]]; then
    FONT_DIR="$HOME/Library/Fonts"
else
    FONT_DIR="$HOME/.local/share/fonts"
    mkdir -p "$FONT_DIR"
fi

if [ ! -f "$FONT_DIR/AnonymiceProNerdFontMono-Regular.ttf" ]; then
    echo "Installing nerd fonts..."
    curl -fLo "$FONT_DIR/AnonymiceProNerdFontMono-Regular.ttf" https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/AnonymousPro/Regular/AnonymiceProNerdFontMono-Regular.ttf
    
    # Refresh font cache on Linux
    if [[ "$OSTYPE" != "darwin"* ]]; then
        echo "Refreshing font cache..."
        fc-cache -f -v
    fi
fi
