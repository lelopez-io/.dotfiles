#!/bin/bash
set -e

echo "=== Installing Core Dependencies ==="

# Install OS-specific foundational dependencies
if [[ "$OSTYPE" == "darwin"* ]]; then
    # MacOS - Install Xcode Command Line Tools if not already installed
    if ! xcode-select -p &>/dev/null; then
        echo "Installing Xcode Command Line Tools..."
        xcode-select --install
        # Wait for the installation to complete since it's a prereq for many tools
        echo "Please complete the Xcode Command Line Tools installation before continuing."
        echo "Press Enter once installation is complete..."
        read
    else
        echo "Xcode Command Line Tools already installed."
    fi
else
    # Linux - Install build essentials, git, and zsh if not already installed
    if command -v apt-get &>/dev/null; then
        echo "Installing build essentials, git, and zsh..."
        sudo apt-get update
        sudo apt-get install -y build-essential git zsh
        
        # Set zsh as default shell if it's not already
        if [[ "$SHELL" != *"zsh"* ]]; then
            echo "Setting zsh as default shell..."
            sudo chsh -s $(which zsh) $USER
        fi
    else
        echo "Non-Debian/Ubuntu Linux detected. Please install build essentials, git, and zsh manually."
    fi
fi

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

# Install Ruby dependencies
echo "Installing Ruby dependencies..."
if [[ "$OSTYPE" != "darwin"* ]]; then
    # Linux requires additional dependencies
    if command -v apt-get &>/dev/null; then
        echo "Installing Ruby build dependencies on Linux..."
        sudo apt-get update
        sudo apt-get install -y build-essential libssl-dev zlib1g-dev libyaml-dev \
            libreadline-dev libncurses5-dev libffi-dev libgdbm-dev
    fi
    
    # Install OpenSSL via Homebrew for Ruby on Linux
    echo "Installing OpenSSL for Ruby..."
    brew install openssl@3.0
fi

# Install libyaml (needed for both macOS and Linux)
echo "Installing libyaml..."
brew install libyaml