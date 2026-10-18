# homebrew: macOS only, on Arch these tools come from pacman. The other
# macOS-only blocks below guard on their path existing so a Linux login
# stays silent.
[ -x /opt/homebrew/bin/brew ] && eval "$(/opt/homebrew/bin/brew shellenv)"

# default editor
export EDITOR="nvim"

# 256 color support
export TERM=xterm-256color

# tools-bun
export PATH="$HOME/.bun/bin:$PATH"


# rancher-desktop, on the way out: brew provides docker, compose and kubectl
# now, so this trails them and only backstops a machine still running it.
[ -d "$HOME/.rd/bin" ] && export PATH="$PATH:$HOME/.rd/bin"

# gcloud
[ -d /opt/homebrew/share/google-cloud-sdk/bin ] && export PATH="/opt/homebrew/share/google-cloud-sdk/bin:$PATH"

# prettierd
export PRETTIERD_DEFAULT_CONFIG="$HOME/.prettierrc"

# mermaid-cli (uses ungoogled-chromium via brew)
if (( $+commands[brew] )); then
    _chromium=("$(brew --prefix)"/Caskroom/ungoogled-chromium/*/Chromium.app/Contents/MacOS/Chromium(N))
    export PUPPETEER_EXECUTABLE_PATH="${_chromium[1]:-}"
    unset _chromium
fi

# gnu-sed
[ -d /opt/homebrew/opt/gnu-sed/libexec/gnubin ] && PATH="/opt/homebrew/opt/gnu-sed/libexec/gnubin:$PATH"

# android sdk (installed via android-studio cask)
if [ -d "$HOME/Library/Android/sdk" ]; then
    export ANDROID_HOME="$HOME/Library/Android/sdk"
    export PATH="$ANDROID_HOME/platform-tools:$PATH"
fi

# user tools LAST: every block above prepends, so this must come last to win.
# Shims in ~/.local/bin (e.g. pi -> pie) rely on outranking ~/.bun/bin.
export PATH="$HOME/.local/bin:$PATH"
