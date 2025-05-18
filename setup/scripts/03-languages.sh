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

# Install all tools defined in config.toml
echo "Installing all configured languages from .config/mise/config.toml..."
mise install --yes

# Set global versions for common languages
echo "Setting global language versions..."
mise use --yes --global node@lts
mise use --yes --global python@3.12
mise use --yes --global ruby@latest
