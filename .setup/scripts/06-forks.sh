#!/bin/bash
set -e

echo "=== Building Patched Forks ==="

# The stowed serie/herdr configs rely on fork-only features; these builds
# shadow the brew fallbacks via ~/.local/bin. Toolchains: 03-languages.sh.
for updater in serie-fork-update herdr-fork-update; do
    if ! "$HOME/.local/bin/$updater"; then
        echo "Warning: $updater failed — the stock brew binary stays active. Continuing..."
    fi
done

# Agent-state hooks are herdr-versioned assets, not stowable files. The
# absolute path skips PATH, which lacks ~/.local/bin during setup.
for target in claude pi; do
    "$HOME/.local/bin/herdr" integration install "$target" \
        || echo "Warning: herdr integration install $target failed. Continuing..."
done
