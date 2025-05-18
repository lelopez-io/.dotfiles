#!/bin/bash
set -e

echo "=== Setting up Language Environments ==="

# Ensure mise is in PATH
if ! eval "$(mise activate bash)"; then
    echo "Error: Failed to activate mise"
    exit 1
fi

# Set Ruby configuration options based on OS
if [[ "$OSTYPE" != "darwin"* ]]; then
    # On Linux, use OpenSSL from Homebrew (installed in core.sh)
    echo "Setting up Ruby configuration for Linux..."
    export RUBY_CONFIGURE_OPTS="--with-openssl-dir=$(brew --prefix openssl@3.0)"
else
    # On macOS, we use libyaml (installed in core.sh)
    echo "Setting up Ruby configuration for macOS..."
    export RUBY_CONFIGURE_OPTS="--with-libyaml-dir=$(brew --prefix libyaml)"
fi

# Install and set up Node.js
echo "Setting up Node.js..."
mise use --global node@lts

# Install and set up Python
echo "Setting up Python..."
mise use --global python@3.12

# Install and set up Ruby
echo "Setting up Ruby..."
mise use --global ruby@latest

# Verify installations
echo "Verifying language installations..."
echo "Node.js: $(mise exec node -- node --version)"
echo "Python: $(mise exec python -- python --version)"
echo "Ruby: $(mise exec ruby -- ruby --version)"