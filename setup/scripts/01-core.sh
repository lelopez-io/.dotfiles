#!/bin/bash
set -e

echo "=== Installing Core Dependencies ==="

# Check for Homebrew
if ! command -v brew &>/dev/null; then
    echo "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    
    # Add Homebrew to PATH for the current session
    if [[ "$OSTYPE" == "darwin"* ]]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
    else
        eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
    fi
fi

# Install essential dependencies for Ruby
if [[ "$OSTYPE" != "darwin"* ]]; then
    # Install OpenSSL via Homebrew for Ruby on Linux
    echo "Installing OpenSSL for Ruby..."
    brew install openssl@3.0
fi

# Install libyaml (needed for both macOS and Linux)
echo "Installing libyaml for Ruby..."
brew install libyaml