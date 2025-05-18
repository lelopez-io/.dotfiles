#!/bin/bash
set -e

echo "=== Setting up Language Environments ==="

# Set Ruby configuration options based on OS first (needs to be set before mise installs Ruby)
if [[ "$OSTYPE" != "darwin"* ]]; then
    # On Linux, use OpenSSL from Homebrew (installed in core.sh)
    echo "Setting up Ruby configuration for Linux..."
    export RUBY_CONFIGURE_OPTS="--with-openssl-dir=$(brew --prefix openssl@3.0)"
else
    # On macOS, we use libyaml (installed in core.sh)
    echo "Setting up Ruby configuration for macOS..."
    export RUBY_CONFIGURE_OPTS="--with-libyaml-dir=$(brew --prefix libyaml)"
fi

# Ensure mise is in PATH
echo "Activating mise..."
if ! eval "$(mise activate bash)"; then
    echo "Error: Failed to activate mise"
    exit 1
fi

# Trust existing mise config to avoid interactive prompts
echo "Trusting mise configurations..."
mise trust --all

# Install and set up Node.js
echo "Setting up Node.js..."
mise use --yes --global node@22.15.1

# Install and set up Python
echo "Setting up Python..."
mise use --yes --global python@3.12

# Install and set up Ruby
echo "Setting up Ruby..."
mise use --yes --global ruby@3.4.4
