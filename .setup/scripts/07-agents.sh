#!/bin/bash
set -e

echo "=== Setting up Agents ==="

# mise x, not bare bun: on a first run the shell predates 02-dotfiles, so the
# .zprofile that puts bun on PATH is not active and bun does not resolve.
echo "Installing pi..."
mise x bun -- bun add -g @earendil-works/pi-coding-agent \
    || echo "Warning: pi install failed. Continuing..."

# Mirrors real_claude in .local/bin/claude: brew's prefix, then the native
# installer's newest version dir. A PATH lookup would find the wrapper
# itself, or nothing while ~/.local/bin is not on PATH during setup.
wrapper_finds_claude() {
    [ -x /opt/homebrew/bin/claude ] && return 0
    local latest
    # shellcheck disable=SC2012 # mtime-ordered, same as the wrapper it mirrors.
    latest=$(ls -dt "$HOME"/.local/share/claude/versions/* 2>/dev/null | head -1)
    [ -n "$latest" ] && [ -x "$latest" ]
}

if [[ "$OSTYPE" != "darwin"* ]] && ! wrapper_finds_claude; then
    echo "Installing Claude Code (native installer)..."
    DOTFILES_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
    wrapper_link="$HOME/.local/bin/claude"

    # The installer drops its own launcher at ~/.local/bin/claude. Remove the
    # stowed wrapper first so it cannot be replaced or written through into
    # the repo, then remove the launcher and let 02 restow the wrapper.
    if [ -L "$wrapper_link" ]; then
        rm "$wrapper_link"
    fi
    installer=$(mktemp)
    curl -fsSL https://claude.ai/install.sh -o "$installer"
    echo "Running Anthropic's installer; script kept at $installer until done"
    bash "$installer" || echo "Warning: Claude Code install failed. Continuing..."
    rm -f "$installer"

    rm -f "$wrapper_link"
    bash "$DOTFILES_ROOT/.setup/scripts/02-dotfiles.sh"

    # claude's own install step does shell integration; if that reached a
    # stowed rc file through its link, the edit landed in the repo.
    if [ -n "$(git -C "$DOTFILES_ROOT" status --porcelain)" ]; then
        echo "Warning: the installer modified stowed files in the dotfiles repo:" >&2
        git -C "$DOTFILES_ROOT" status --short >&2
    fi
fi

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
# command -v alone misses the native install while ~/.local/bin is off PATH.
if command -v claude &> /dev/null || wrapper_finds_claude; then
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
