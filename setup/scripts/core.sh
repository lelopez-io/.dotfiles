#!/bin/bash
set -e

echo "=== Installing Core Dependencies ==="

# Check for Xcode Command Line Tools
if ! xcode-select -p &>/dev/null; then
    echo "Installing Xcode Command Line Tools..."
    xcode-select --install
    # Wait for installation to complete
    until xcode-select -p &>/dev/null; do
        sleep 5
    done
fi

# Check for Homebrew
if ! command -v brew &>/dev/null; then
    echo "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    
    # Add Homebrew to PATH for the current session
    eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# Check for mise
if ! command -v mise &>/dev/null; then
    echo "Installing mise..."
    curl https://mise.jdx.dev/install.sh | sh
fi