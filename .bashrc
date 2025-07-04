# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    if [ -f ~/.PS1 ]; then
        . ~/.PS1
    else
#        PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
        PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
    fi
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# used for adding git details to the prompt
if [ -f ~/.git-prompt.sh ]; then
    . ~/.git-prompt.sh
fi

# branch name completion

if [ -f ~/.git-completion.sh ]; then
    . ~/.git-completion.sh
fi

if [ -f ~/.intellij.sh ]; then
    . ~/.intellij.sh
fi

# vim mode
set -o vi

export ANDROID_SDK_ROOT=~/Code/Android
PATH=$PATH:$(go env GOPATH)/bin
export PATH=$PATH:/home/bpayne/.bin
export PATH=$PATH:/home/bpayne/.local/bin
#eval "$(jira --completion-script-bash)"

export DOCKER_HOST="unix:///var/run/docker.sock"

export VISUAL=vim
export EDITOR="$VISUAL"
alias viqtile='vim /home/bpayne/.config/qtile/config.py'
alias vitodo='vim /home/bpayne/Documents/notes/todo.txt'
if [[ -e ~/.cdable_vars.sh ]]; then
    . ~/.cdable_vars.sh
fi
if [[ -z "$SSH_CONNECTION" && -z "$TMUX" ]]; then
    SESSION_NAME=$(grep -E '^[a-z]{5}$' /usr/share/dict/esperanto | shuf -n 2 | tr '\n' '-' | sed 's/.$//')
    exec tmux new-session -s "$SESSION_NAME"
fi
if [[ -e "$HOME/.cargo/env" ]]; then
    . "$HOME/.cargo/env"
fi
export LESS='-R'

export PROMPT_COMMAND='history -a; command=$(history 1 | sed "s/^[ ]*[0-9]*[ ]*//"); logger -p user.notice -t bash_command "$USER: $command"'

if [ -f ~/Code/Github/tmux-bash-completion/completions/tmux ]; then
    . ~/Code/Github/tmux-bash-completion/completions/tmux
fi

eval "$(direnv hook bash)"

# pyenv
if [[ -e ~/.pyenv.sh ]]; then
    . ~/.pyenv.sh
fi

# github
if [[ -e ~/.gh.sh ]]; then
    . ~/.gh.sh
fi

# k8 in docker
if [[ -e ~/.kind.sh ]]; then
    . ~/.kind.sh
fi

# helm
if [[ -e ~/.helm.sh ]]; then
    . ~/.helm.sh
fi

git config --global --unset-all mine.repo
ls -1 /home/bpayne/Code/mine | xargs -I {} git config --global --add mine.repo /home/bpayne/Code/mine/{}
complete -C '/home/bpayne/.local/bin/aws_completer' aws
