# oh-my-zsh
export ZSH="$HOME/.oh-my-zsh"

# theme
ZSH_THEME="spaceship"

# plugins
plugins=(
    git
    history
    kubectl
    zsh-syntax-highlighting
    zsh-autosuggestions
)

# config-files
source $ZSH/oh-my-zsh.sh
source $HOME/.zprompt
source $HOME/.ztools
source $HOME/.zaliases
source $HOME/.zfunctions
