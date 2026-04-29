# default editor
export EDITOR="nvim"

# 256 color support
export TERM=xterm-256color

# tools
export PATH="$HOME/.local/bin:$PATH"

# rancher-desktop
export PATH="$HOME/.rd/bin:$PATH"

# gcloud
[ -s "$HOME/.gcloud/path.zsh.inc" ] && \. "$HOME/.gcloud/path.zsh.inc"
export USE_GKE_GCLOUD_AUTH_PLUGIN=True

# andriod sdk
export ANDROID_HOME="$HOME/Library/Android/sdk"
export PATH="$ANDROID_HOME/tools:$ANDROID_HOME/tools/bin:$ANDROID_HOME/platform-tools:$PATH"

# prettierd
export PRETTIERD_DEFAULT_CONFIG="$HOME/.prettierrc"

# gnu-sed
PATH="/opt/homebrew/opt/gnu-sed/libexec/gnubin:$PATH"

