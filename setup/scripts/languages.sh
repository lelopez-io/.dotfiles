#!/bin/bash
set -e

echo "=== Setting up Language Environments ==="

# Ensure mise is in PATH
eval "$(mise activate bash)"

# Install and set up Node.js
echo "Setting up Node.js..."
mise use --global node@20
mise install node@20

# Install and set up Python
echo "Setting up Python..."
mise use --global python@3.12
mise install python@3.12

# Install and set up Ruby
echo "Setting up Ruby..."
mise use --global ruby@3.2.2
mise install ruby@3.2.2

# Install global packages
echo "Installing global Node.js packages..."
npm install -g prettier typescript

echo "Installing global Python packages..."
pip install --user pipenv black

echo "Installing global Ruby packages..."
gem install bundler
gem install colorls