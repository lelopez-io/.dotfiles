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

# ghostty maps cmd+enter to Ctrl-S (hunk note save); ^S must not freeze the shell
setopt no_flow_control

# completions
fpath=(~/.zsh/completions $fpath)
autoload -Uz compinit && compinit

# prompt
eval "$(starship init zsh)"

# fzf
source <(fzf --zsh)

# plugins: brew puts them under /opt/homebrew/share, pacman under
# /usr/share/zsh/plugins; source the first prefix that has each one.
for plugin in zsh-autosuggestions zsh-syntax-highlighting; do
    for prefix in /opt/homebrew/share /usr/share/zsh/plugins; do
        [[ -f $prefix/$plugin/$plugin.zsh ]] || continue
        source "$prefix/$plugin/$plugin.zsh"
        break
    done
done
unset plugin prefix

# config-files
source $HOME/.zaliases
source $HOME/.zfunctions
source $HOME/.zoptions

# local overrides (untracked, non-secret — template: .zshrc.local.example)
[[ -f $HOME/.zshrc.local ]] && source $HOME/.zshrc.local
