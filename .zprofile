# homebrew
eval "$(/opt/homebrew/bin/brew shellenv)"

# default editor
export EDITOR="nvim"

# 256 color support
export TERM=xterm-256color

# tools
export PATH="$HOME/.local/bin:$PATH"

# rancher-desktop
export PATH="$HOME/.rd/bin:$PATH"

# prettierd
export PRETTIERD_DEFAULT_CONFIG="$HOME/.prettierrc"

# mermaid-cli (uses ungoogled-chromium via brew)
_chromium=("$(brew --prefix)"/Caskroom/ungoogled-chromium/*/Chromium.app/Contents/MacOS/Chromium(N))
export PUPPETEER_EXECUTABLE_PATH="${_chromium[1]:-}"
unset _chromium

# gnu-sed
PATH="/opt/homebrew/opt/gnu-sed/libexec/gnubin:$PATH"

