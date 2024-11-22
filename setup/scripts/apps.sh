#!/bin/bash
set -e

SETUP_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
BREWFILE="$SETUP_DIR/Brewfile"

echo "=== Installing Applications ==="

if [ ! -f "$BREWFILE" ]; then
    echo "Error: Brewfile not found. Please run configure.sh first."
    exit 1
fi

# Install all Homebrew packages
echo "Installing packages from Brewfile..."
brew bundle --file="$BREWFILE"