#!/bin/bash
set -e

SETUP_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SCRIPTS_DIR="$SETUP_DIR/scripts"

echo "=== Starting Development Environment Setup ==="

echo "Installing core dependencies..."
source "$SCRIPTS_DIR/00-core.sh"

# Always run tool selection, it will handle existing Brewfiles appropriately
echo "Setting up tool selection..."
"$SCRIPTS_DIR/01-tool-select.sh"

echo "Installing selected tools and applications..."
source "$SCRIPTS_DIR/02-tool-install.sh"

echo "Setting up language environments..."
source "$SCRIPTS_DIR/03-languages.sh"

echo "Setting up shell environment..."
source "$SCRIPTS_DIR/04-shell.sh"

echo "Setting up Git configuration..."
source "$SCRIPTS_DIR/05-git.sh"

echo "Setting up dotfiles..."
source "$SCRIPTS_DIR/06-dotfiles.sh"

echo "=== Setup Complete! ==="
echo "NOTE: You may need to restart your terminal for all changes to take effect."