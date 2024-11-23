#!/bin/bash
set -e

# Helper function for yes/no prompts
confirm() {
    while true; do
        read -p "$1 (y/n) " yn
        case $yn in
            [Yy]* ) return 0;;
            [Nn]* ) return 1;;
            * ) echo "Please answer yes (y) or no (n).";;
        esac
    done
}

# Parse command line arguments
FORCE_CONFIG=false
for arg in "$@"; do
    case $arg in
        -f|--force)
            FORCE_CONFIG=true
            shift # Remove --force from processing
            ;;
    esac
done


SETUP_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SCRIPTS_DIR="$SETUP_DIR/scripts"

echo "=== Starting Development Environment Setup ==="

# Run configuration if needed
if [ ! -f "$SETUP_DIR/Brewfile" ] || [ "$FORCE_CONFIG" = true ]; then
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

# Set default branch to main if not set
if [ -z "$(git config --global init.defaultBranch)" ]; then
    git config --global init.defaultBranch main
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
cd "$HOME/.dotfiles"

if confirm "Would you like to force repo files to overwrite existing files? (This will overwrite your current configs)"; then
    echo "Force installing dotfiles..."
    stow . --restow
else
    echo "Adopting existing files..."
    stow . --adopt
    echo "NOTE: Review git changes and commit what you want to keep, or"
    echo "      discard changes if you only want what's in the repo."
    echo "      Then re-run 'stow . --restow' to force repo versions"
fi

echo "Setting up additional symlinks..."
ln -sf "$HOME/.dotfiles/.gitignore" "$HOME/.gitignore"
ln -sf "$HOME/.dotfiles/.env.aider" "$HOME/.env.aider"

# Configure git to use global gitignore
git config --global core.excludesfile ~/.gitignore

echo "=== Setup Complete! ==="
echo "NOTE: You may need to restart your terminal for all changes to take effect."
