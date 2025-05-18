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


SETUP_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SCRIPTS_DIR="$SETUP_DIR/scripts"

echo "=== Starting Development Environment Setup ==="

# Run configuration if needed
if [ ! -f "$SETUP_DIR/Brewfile" ] || [ "$FORCE_CONFIG" = true ]; then
    echo "Initial configuration required..."
    "$SCRIPTS_DIR/00-configure.sh"
fi

# Run installation scripts
echo "Installing core dependencies..."
source "$SCRIPTS_DIR/01-core.sh"

echo "Installing applications..."
source "$SCRIPTS_DIR/02-apps.sh"

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