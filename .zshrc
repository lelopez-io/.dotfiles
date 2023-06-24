# oh-my-zsh
export ZSH="$HOME/.oh-my-zsh"

# theme
ZSH_THEME="spaceship"

# plugins
plugins=(
    brew
    git
    history
    kubectl
    kube-ps1
    zsh-syntax-highlighting
)

# config-files
source $ZSH/oh-my-zsh.sh
source $HOME/.zsh_prompt
source $HOME/.zsh_profile
source $HOME/.zsh_aliases
