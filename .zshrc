# history
HISTFILE="$HOME/.zsh_history"
HISTSIZE=50000
SAVEHIST=10000
setopt extended_history
setopt hist_expire_dups_first
setopt hist_ignore_dups
setopt hist_ignore_space
setopt hist_verify
setopt share_history

# completions
fpath=(~/.zsh/completions $fpath)
autoload -Uz compinit && compinit

# prompt
eval "$(starship init zsh)"

# plugins
source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# config-files
source $HOME/.ztools
source $HOME/.zaliases
source $HOME/.zfunctions
