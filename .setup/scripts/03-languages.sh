#!/bin/bash
set -e

echo "=== Setting up Language Environments ==="

# Ruby builds against Homebrew libraries when present (optional in Brewfile)
if [[ "$OSTYPE" == "darwin"* ]]; then
    if [ -d "$(brew --prefix)/opt/libyaml" ]; then
        export RUBY_CONFIGURE_OPTS="--with-libyaml-dir=$(brew --prefix)/opt/libyaml"
    fi
else
    if [ -d "$(brew --prefix)/opt/openssl@3.0" ]; then
        export RUBY_CONFIGURE_OPTS="--with-openssl-dir=$(brew --prefix)/opt/openssl@3.0"
    fi
fi

# Versions are declared in the stowed global config (.config/mise/config.toml),
# so this must run after 02-dotfiles.sh
echo "Installing language runtimes from mise config..."
mise install --yes
