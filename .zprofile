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

# gnu-sed
PATH="/opt/homebrew/opt/gnu-sed/libexec/gnubin:$PATH"

