# If you come from bash you might have to change your $PATH.
export PATH=$HOME/bin:/usr/local/bin:$PATH
export PATH=/Library/TeX/texbin:$PATH
export GOPATH=$HOME/.go
export PATH=$PATH:$GOROOT/bin:$GOPATH/bin

# Path to your oh-my-zsh installation.
export ZSH="/Users/lelopez/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
# POWERLEVEL9K_MODE='awesome-patched'
ZSH_THEME='powerlevel9k/powerlevel9k'
POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(vcs dir rbenv)
POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(status)
POWERLEVEL9K_SHORTEN_DIR_LENGTH=2
POWERLEVEL9K_VCS_CLEAN_FOREGROUND='BLACK'
POWERLEVEL9K_VCS_UNTRACKED_FOREGROUND='BLACK'
POWERLEVEL9K_VCS_MODIFIED_FOREGROUND='BLACK'

# ZSH_THEME="avit"
code () { VSCODE_CWD="$PWD" open -n -b "com.microsoft.VSCode" --args $* ;}

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/lelopez/Downloads/google-cloud-sdk/path.bash.inc' ]; then source '/Users/lelopez/Downloads/google-cloud-sdk/path.bash.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/lelopez/Downloads/google-cloud-sdk/completion.bash.inc' ]; then source '/Users/lelopez/Downloads/google-cloud-sdk/completion.bash.inc'; fi


# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to display red dots whilst waiting for completion.
COMPLETION_WAITING_DOTS="true"

# Which plugins would you like to load?
# Standard plugins can be found in ~/.oh-my-zsh/plugins/*
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
  git
  osx
)

source $ZSH/oh-my-zsh.sh
source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /usr/local/share/zsh-autosuggestions/zsh-autosuggestions.zsh

# User configuration

# Set up PYENV
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/rsa_id"

# Aliases
alias l='gls -lFh --color=auto --group-directories-first'
alias ll='gls -lFh --color=auto --group-directories-first'
alias ls='gls -lFh --color=auto --group-directories-first'
alias la='gls -lFha --color=auto --group-directories-first'

eval `gdircolors ~/.oh-my-zsh/custom/themes/dircolors.256dark`

# tabtab source for serverless package
# uninstall by removing these lines or running `tabtab uninstall serverless`
[[ -f /Users/lelopez/.go/src/node_modules/tabtab/.completions/serverless.zsh ]] && . /Users/lelopez/.go/src/node_modules/tabtab/.completions/serverless.zsh
# tabtab source for sls package
# uninstall by removing these lines or running `tabtab uninstall sls`
[[ -f /Users/lelopez/.go/src/node_modules/tabtab/.completions/sls.zsh ]] && . /Users/lelopez/.go/src/node_modules/tabtab/.completions/sls.zsh
# tabtab source for slss package
# uninstall by removing these lines or running `tabtab uninstall slss`
[[ -f /Users/lelopez/.go/src/node_modules/tabtab/.completions/slss.zsh ]] && . /Users/lelopez/.go/src/node_modules/tabtab/.completions/slss.zsh
