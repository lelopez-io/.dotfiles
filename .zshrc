# Path to oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# 
export PATH=/bin:/usr/bin:/usr/local/bin:${PATH}

# Path to rbenv installation and init
export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init - zsh)"

# Path to nvm installation and init
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# Path to Flutter installation
export PATH="$HOME/za/flutter/bin:$PATH"

# Path to Fly installation
export PATH="$HOME/za/fly:$PATH"

# Path to Java installation
export JAVA_HOME="/Library/Java/JavaVirtualMachines/jdk1.8.0_301.jdk/Contents/Home"
export PATH=$JAVA_HOME/bin:$PATH

# Path to Andriod Platform Tools
export PATH="$HOME/Library/Android/sdk/platform-tools:$PATH"

# Path to serverless 
export PATH="$HOME/.serverless/bin:$PATH"

# Path to Golang
export GOPATH=$HOME/za/go
export GOROOT="$(brew --prefix golang)/libexec"
export PATH="$PATH:${GOPATH}/bin:${GOROOT}/bin"

# PATH for the Google Cloud SDK.
if [ -f $HOME'/za/google-cloud-sdk/path.zsh.inc' ]; then . $HOME'/za/google-cloud-sdk/path.zsh.inc'; fi

# Enable command completion for gcloud.
if [ -f $HOME'/za/google-cloud-sdk/completion.zsh.inc' ]; then . $HOME'/za/google-cloud-sdk/completion.zsh.inc'; fi

# Terminal Style options
ZSH_THEME="spaceship"

# Options
COMPLETION_WAITING_DOTS=true
SPACESHIP_GCLOUD_SHOW=false
SPACESHIP_DOCKER_SHOW=false
SPACESHIP_PROMPT_ADD_NEWLINE=false
SPACESHIP_PROMPT_SEPARATE_LINE=false
SPACESHIP_CHAR_SYMBOL=''

KUBE_PS1_SYMBOL_ENABLE=false
KUBE_PS1_PREFIX=''
KUBE_PS1_SUFFIX=' '

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
    brew
    git
    history
    kubectl
    zsh-syntax-highlighting
)

# User configuration
source $ZSH/oh-my-zsh.sh
source $(dirname $(gem which colorls))/tab_complete.sh
source "/usr/local/opt/kube-ps1/share/kube-ps1.sh"

PROMPT_KUBE=$'\n''$(kube_ps1)'
PROMPT_DIVIDER=$'\033[0;32m∴ \033[0m'
PROMPT_ARROW=$'\n'"%(?:%{$fg_bold[green]%}%{%G➜%} :%{$fg_bold[red]%}%{%G➜%} )"
PROMPT=$PROMPT_KUBE$PROMPT_DIVIDER$PROMPT$PROMPT_ARROW


# Tmux/venv config
if [ -n "$VIRTUAL_ENV" ]; then
  source "$VIRTUAL_ENV/bin/activate"
else
  # workon default
fi

# Aliases
alias ls='colorls --group-directories-first'
alias l='colorls --group-directories-first --almost-all'
alias ll='colorls --group-directories-first --long'
alias lt='tree -LFC 2 --dirsfirst'

alias pv='source ./venv/bin/activate'
alias pd='deactivate'

alias k='kubectl'
alias kd='k --dry-run=client -o yaml'
alias kn='k config set-context --current --namespace'
alias ka='k get deploy,rs,po,svc,ep'
alias kn='kubens'
alias kc='kubectx'

alias mk='minikube'
alias dc='docker-compose'

complete -F __start_kubectl k
fpath=(~/.zsh/completions $fpath)
autoload -U compinit && compinit

# fix Hyper first line precent sign
unsetopt PROMPT_SP
export LC_ALL=en_US.UTF-8
