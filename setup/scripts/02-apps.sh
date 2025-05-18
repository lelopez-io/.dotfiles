#!/bin/bash
set -e

SETUP_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
BREWFILE="$SETUP_DIR/Brewfile"

echo "=== Installing Applications ==="

# Check if Brewfile exists
if [ ! -f "$BREWFILE" ]; then
    echo "Error: Brewfile not found at $BREWFILE"
    echo "Please run configure.sh first or run install.sh with the -f flag to force configuration."
    exit 1
fi

# Display Brewfile contents
echo "The following applications will be installed:"
echo "-----------------------------------------"
cat "$BREWFILE" | grep -v "^#" | grep -v "^$" | sed 's/^/  /'
echo "-----------------------------------------"

# Install all Homebrew packages
echo "Installing packages from Brewfile..."
if ! brew bundle --file="$BREWFILE"; then
    echo "Warning: Some packages failed to install. Check the output above for details."
    echo "You can try running 'brew bundle --file=\"$BREWFILE\"' manually after fixing any issues."
    
    # Continue with installation despite errors
    echo "Continuing with installation..."
else
    echo "All packages installed successfully!"
fi