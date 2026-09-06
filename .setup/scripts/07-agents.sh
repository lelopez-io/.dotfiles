#!/bin/bash
set -e

echo "=== Setting up Agents ==="

# mise x, not bare bun: on a first run the shell predates 02-dotfiles, so the
# .zprofile that puts bun on PATH is not active and bun does not resolve.
echo "Installing pi..."
mise x bun -- bun add -g @earendil-works/pi-coding-agent \
    || echo "Warning: pi install failed. Continuing..."

# Agent-state hooks are herdr-versioned assets, not stowable files. The
# absolute path skips PATH, which lacks ~/.local/bin during setup.
for target in claude pi; do
    "$HOME/.local/bin/herdr" integration install "$target" \
        || echo "Warning: herdr integration install $target failed. Continuing..."
done
