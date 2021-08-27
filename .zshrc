# Path to oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

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
export PATH="/Users/luis/Library/Android/sdk/platform-tools:$PATH"

# Path to serverless 
export PATH="$HOME/.serverless/bin:$PATH"

# Path to Golang
export GOPATH=$HOME/za/go
export GOROOT="$(brew --prefix golang)/libexec"
export PATH="$PATH:${GOPATH}/bin:${GOROOT}/bin"

# PATH for the Google Cloud SDK.
if [ -f '/Users/luis/za/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/luis/za/google-cloud-sdk/path.zsh.inc'; fi

# Enable command completion for gcloud.
if [ -f '/Users/luis/za/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/luis/za/google-cloud-sdk/completion.zsh.inc'; fi

# Terminal Style options
ZSH_THEME="spaceship"
COMPLETION_WAITING_DOTS="true"


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
alias kn='k config set-context --current --namespace'
alias ka='k get deploy,rs,po,svc,ep'
alias kns='kubens'
alias kctx='kubectx'

alias mk='minikube'
alias dc='docker-compose'

# fix Hyper first line precent sign
unsetopt PROMPT_SP
