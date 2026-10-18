#!/bin/bash
set -e

echo "=== Setting up Language Environments ==="

# Ruby builds against Homebrew libraries when present (optional in Brewfile)
if [[ "$OSTYPE" == "darwin"* ]]; then
    if [ -d "$(brew --prefix)/opt/libyaml" ]; then
        export RUBY_CONFIGURE_OPTS="--with-libyaml-dir=$(brew --prefix)/opt/libyaml"
    fi
elif command -v pacman &>/dev/null; then
    # ruby-build links Arch's system libraries without a configure flag; the
    # headers just have to be installed before mise compiles ruby.
    sudo pacman -S --needed --noconfirm openssl libyaml libffi zlib
else
    if [ -d "$(brew --prefix)/opt/openssl@3.0" ]; then
        export RUBY_CONFIGURE_OPTS="--with-openssl-dir=$(brew --prefix)/opt/openssl@3.0"
    fi
fi

# Versions are declared in the stowed global config (.config/mise/config.toml),
# so this must run after 02-dotfiles.sh
echo "Installing language runtimes from mise config..."
# One runtime failing to build should not cost the stages after this. 06 and
# 07 already warn when a toolchain is missing, so they report it in context.
mise install --yes \
    || echo "Warning: some runtimes failed to install. Later stages may lack them."
