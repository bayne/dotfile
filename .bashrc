[[ "${TERM}" != "dumb" && -f /etc/bashrc ]] && . /etc/bashrc
source ~/.git-completion.sh
PS1='\[\e[1;31m\][\u\[\e[0m\]@\[\e[1;32m\]\h:\W%]\$\[\e[0m\] '
#PS1='\[\e[1;32m\][\u@\h \W]\$\[\e[0m\] '
#PS1='\u@\h:\W% '

PATH=~/.bin:$PATH:/net/bin

alias vi=vim
alias ls='ls --color'
alias gits='git status'
alias gitc='git checkout'

if [[ $TERM == "xterm" ]]; then
    export TERM=xterm-256color
fi
