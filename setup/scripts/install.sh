#!/bin/bash
set -e

SETUP_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SCRIPTS_DIR="$SETUP_DIR/scripts"

echo "=== Starting Development Environment Setup ==="

# Run configuration if needed
if [ ! -f "$SETUP_DIR/Brewfile" ]; then
    echo "Initial configuration required..."
    "$SETUP_DIR/configure.sh"
fi

# Configure git if not already set
if [ -z "$(git config --global user.name)" ]; then
    read -p "Enter your Git name: " git_name
    git config --global user.name "$git_name"
fi

if [ -z "$(git config --global user.email)" ]; then
    read -p "Enter your Git email: " git_email
    git config --global user.email "$git_email"
fi

# Run installation scripts
echo "Installing core dependencies..."
source "$SCRIPTS_DIR/core.sh"

echo "Installing applications..."
source "$SCRIPTS_DIR/apps.sh"

echo "Setting up language environments..."
source "$SCRIPTS_DIR/languages.sh"

echo "Setting up shell environment..."
source "$SCRIPTS_DIR/shell.sh"

# Setup dotfiles with stow
echo "Setting up dotfiles..."
cd "$HOME/.dotfiles" && stow .

echo "Setting up additional symlinks..."
ln -sf "$HOME/.dotfiles/.gitignore" "$HOME/.gitignore"
ln -sf "$HOME/.dotfiles/.env.aider" "$HOME/.env.aider"

# Configure git to use global gitignore
git config --global core.excludesfile ~/.gitignore

echo "=== Setup Complete! ==="
echo "NOTE: You may need to restart your terminal for all changes to take effect."
