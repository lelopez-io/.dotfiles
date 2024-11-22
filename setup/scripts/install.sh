#!/bin/bash
set -e

SETUP_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SCRIPTS_DIR="$SETUP_DIR/scripts"

echo "=== Starting Development Environment Setup ==="

# Run configuration if needed
if [ ! -f "$SETUP_DIR/Brewfile" ] || [ ! -f "$SETUP_DIR/git-config.sh" ]; then
    echo "Initial configuration required..."
    "$SETUP_DIR/configure.sh"
fi

# Source the git config if it exists
if [ -f "$SETUP_DIR/git-config.sh" ]; then
    source "$SETUP_DIR/git-config.sh"
fi

# Run installation scripts
echo "Installing core dependencies..."
source "$SCRIPTS_DIR/core.sh"

echo "Installing applications..."
source "$SCRIPTS_DIR/apps.sh"

echo "Setting up language environments..."
source "$SCRIPTS_DIR/languages.sh"

# Setup dotfiles with stow
echo "Setting up dotfiles..."
cd "$HOME/.dotfiles" && stow .

echo "=== Setup Complete! ==="
echo "NOTE: You may need to restart your terminal for all changes to take effect."
