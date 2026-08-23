# rustup env, guarded so machines without rust are unaffected.
# Sourced before the PATH export so ~/.local/bin stays ahead of
# ~/.cargo/bin (shims win over rustup proxies).
[ -f "$HOME/.cargo/env" ] && . "$HOME/.cargo/env"

# Non-interactive shells (`ssh host cmd`, herdr --remote) skip .zprofile,
# so user-tool PATH must live here.
export PATH="$HOME/.local/bin:$PATH"
