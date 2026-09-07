#!/bin/bash
set -e

echo "=== Setting up Agents ==="

# mise x, not bare bun: on a first run the shell predates 02-dotfiles, so the
# .zprofile that puts bun on PATH is not active and bun does not resolve.
echo "Installing pi..."
mise x bun -- bun add -g @earendil-works/pi-coding-agent \
    || echo "Warning: pi install failed. Continuing..."

# Agent-state hooks are herdr-versioned assets, not stowable files. Prefer the
# fork, since PATH may not carry ~/.local/bin during setup, but fall back to
# brew's herdr: a failed fork build leaves that path absent entirely.
herdr_bin="$HOME/.local/bin/herdr"
[ -x "$herdr_bin" ] || herdr_bin=$(command -v herdr || true)

# herdr installs the claude hooks into ~/.claude, which Claude Code creates on
# first launch. Setup runs before anyone has opened it, so make the directory:
# the hooks are read whenever that first launch happens. Claude Code never
# rewrites CLAUDE.md, so the global rules file can be a link to the stowed
# copy while other files under ~/.claude stay machine-local.
if command -v claude &> /dev/null; then
    mkdir -p "$HOME/.claude"
    ln -sfn "$HOME/.config/agents/agent-rules.md" "$HOME/.claude/CLAUDE.md"
fi

if [ -n "$herdr_bin" ]; then
    for target in claude pi; do
        "$herdr_bin" integration install "$target" \
            || echo "Warning: herdr integration install $target failed. Continuing..."
    done
else
    echo "Warning: no herdr binary found; skipping agent integrations."
fi
