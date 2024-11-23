#!/bin/bash
set -e

echo "=== Setting up Language Environments ==="

# Ensure mise is in PATH
if ! eval "$(mise activate bash)"; then
    echo "Error: Failed to activate mise"
    exit 1
fi

# Install and set up Node.js
echo "Setting up Node.js..."
mise use --global node@lts

# Install and set up Python
echo "Setting up Python..."
mise use --global python@latest

# Install and set up Ruby
echo "Setting up Ruby..."
mise use --global ruby@latest

# Install global packages
echo "Installing global Node.js packages..."
npm install -g prettier typescript

echo "Installing global Python packages..."
pip install --user pipenv black

echo "Installing global Ruby packages..."
gem install bundler
gem install colorls