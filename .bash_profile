export PATH="/usr/local/sbin:$PATH"

source /usr/local/etc/bash_completion.d/git-prompt.sh
GIT_PS1_SHOWDIRTYSTATE=true
export PS1='\[\e[0;30m\e[47m\]$(__git_ps1) [\w]\$\[\e[m\]'

export EDITOR="mvim"
alias vim="/Users/user/Applications/MacVim.app/Contents/MacOS/Vim"
mvim () { touch "$@" && open -a MacVim "$@"; }

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

code () { VSCODE_CWD="$PWD" open -n -b "com.microsoft.VSCode" --args $* ;}
