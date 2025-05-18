#!/bin/bash
set -e

echo "=== Setting up Shell Configuration ==="

# Git configuration is now handled in 05-git.sh

# Install Ruby gems 
echo "Installing Ruby gems..."
echo "- Installing colorls for enhanced directory listings"
if ! mise exec ruby -- gem install colorls; then
    echo "Warning: Failed to install colorls. Continuing..."
fi

# Install Python packages
echo "Installing Python packages..."
echo "- Installing aider for AI-assisted coding"
if ! mise exec python -- python -m pip install -U aider-chat; then
    echo "Warning: Failed to install aider. Continuing..."
fi

# Install oh-my-zsh if not already installed
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "Installing oh-my-zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    
    # Backup any existing .zshrc file that might be overwritten by oh-my-zsh
    if [ -f "$HOME/.zshrc.pre-oh-my-zsh" ]; then
        echo "Found .zshrc backup from oh-my-zsh installation"
    fi
fi

# Install spaceship prompt
if [ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/spaceship-prompt" ]; then
    echo "Installing spaceship prompt..."
    git clone https://github.com/spaceship-prompt/spaceship-prompt.git "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/spaceship-prompt" --depth=1
    ln -sf "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/spaceship-prompt/spaceship.zsh-theme" "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/spaceship.zsh-theme"
fi

# Install ZSH plugins
echo "Installing ZSH plugins..."

# Install zsh-syntax-highlighting
if [ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting" ]; then
    echo "- Installing zsh-syntax-highlighting..."
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
fi

# Install zsh-autosuggestions
if [ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions" ]; then
    echo "- Installing zsh-autosuggestions..."
    git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
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
