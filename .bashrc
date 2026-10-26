# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples


# If not running interactively, don't do anything
case $- in
    *i*) ;;
    *) return;;
esac

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=-1
HISTFILESIZE=-1
HISTTIMEFORMAT="%F %T "
# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth


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

if [ -f ~/.gcx.sh ]; then
    . ~/.gcx.sh
fi


# vim mode
set -o vi

export ANDROID_SDK_ROOT=~/Code/Android
export ANDROID_HOME=~/Code/Android
PATH=$PATH:$(go env GOPATH)/bin
export PATH=$PATH:/home/bpayne/.cargo/bin
export PATH=$PATH:/home/bpayne/.bin
export PATH=$PATH:/home/bpayne/.local/bin
#eval "$(jira --completion-script-bash)"


export VISUAL=nvim
export EDITOR="$VISUAL"
alias viqtile='vim /home/bpayne/.config/qtile/config.py'
alias vitodo='vim /home/bpayne/Documents/notes/todo.txt'
alias viide='vim /home/bpayne/Documents/notes/ide.txt'
if [[ -e ~/.cdable_vars.sh ]]; then
    . ~/.cdable_vars.sh
fi
#if [[ -n "$ZED_TERM" || ( -z "$SSH_CONNECTION" && -z "$TMUX" && -z "$CLAUDE_CODE" && -v ZED_FORCE_CLI ) || ( "xterm-kitty" == $TERM ) ]]; then
    #SESSION_NAME=$(grep -E '^[a-z]{5}$' /usr/share/dict/esperanto | shuf -n 2 | tr '\n' '-' | sed 's/.$//')
    # exec tmux new-session # -s "$SESSION_NAME"
#fi
if [[ -e "$HOME/.cargo/env" ]]; then
    . "$HOME/.cargo/env"
fi
#if [ -n "$SSH_CONNECTION" ] && [ -n "$TMUX_SESSION" ] && [ -z "$TMUX" ]; then
#    exec tmux attach-session -t "$TMUX_SESSION" 2>/dev/null || exec tmux new-session -s "$TMUX_SESSION"
#fi

export LESS='-R'

if [ -f ~/Code/Github/tmux-bash-completion/completions/tmux ]; then
    . ~/Code/Github/tmux-bash-completion/completions/tmux
fi

eval "$(direnv hook bash)"

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

# 1password
if [[ -e ~/.op.sh ]]; then
    . ~/.op.sh
fi

if [[ -e ~/.kubectl.sh ]]; then
    . ~/.kubectl.sh
fi

if [[ -e ~/.flux.sh ]]; then
    . ~/.flux.sh
fi

if [[ -e ~/.loki.sh ]]; then
    . ~/.loki.sh
fi
if [[ -e ~/.bashrc.local-alias.sh ]]; then
    . ~/.bashrc.local-alias.sh
fi
if [[ -e ~/.forge.sh ]]; then
    . ~/.forge.sh
fi
if [[ -e ~/.dragon.sh ]]; then
    . ~/.dragon.sh
fi
if [[ -e ~/.tmxb.sh ]]; then
    . ~/.tmxb.sh
fi
if [[ -e ~/.hf-tier.sh ]]; then
    . ~/.hf-tier.sh
fi
if [[ -e ~/.rec.sh ]]; then
    . ~/.rec.sh
fi


sops-init() {
  [ -e .sops.yaml ] && { echo ".sops.yaml already exists"; return 1; }
  local pub
  pub=$(age-keygen -y "${SOPS_AGE_KEY_FILE:-$HOME/.config/sops/age/keys.txt}") || return 1
  cat > .sops.yaml <<EOF
creation_rules:
  - path_regex: (^|/)(\.env|secrets/.*\.ya?ml)\$
    age: ${pub}
EOF
  echo "wrote .sops.yaml for ${pub}"
}


#if [[ -e ~/.cl.sh ]]; then
#    . ~/.cl.sh
#fi



export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"


git config --global --unset-all mine.repo
ls -1 /home/bpayne/Code/mine | xargs -I {} git config --global --add mine.repo /home/bpayne/Code/mine/{}
alias podman-rmmysql="podman ps -a --format=json | jq -r '.[] | select(.Names[] | contains(\"workspace\") | not) | select(.Command[]? | contains(\"mysqld\")) | .Names[]' | xargs podman rm -f"
alias podman-rmsftp="podman ps -a --format=json | jq -r '.[] | select(.Names[] | contains(\"workspace\") | not) | select(.Image | contains(\"sftp\")) | .Names[]' | xargs podman rm -f"

complete -C '/home/bpayne/.local/bin/aws_completer' aws

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
eval "$(uv generate-shell-completion bash)"

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"

SF_AC_BASH_SETUP_PATH=/home/bpayne/.cache/sf/autocomplete/bash_setup && test -f $SF_AC_BASH_SETUP_PATH && source $SF_AC_BASH_SETUP_PATH; # sf autocomplete setup
alias dcb-history='F=$(dcb -H | sort -r | hs | cut -f3 -d" ") && [[ -n $F ]] && dcb $F'
alias aws-nonprod='devx cloud aws-login -r "arn:aws:iam::001797876521:role/HuluAdPlatformTeamAccess"'
alias aws-prod='devx cloud aws-login -r "arn:aws:iam::644248783419:role/HuluAdPlatformTeamAccess"'
alias aws-dcops='devx cloud aws-login -r "arn:aws:iam::584878871707:role/HuluAdPlatformTeamAccess"'
alias vault-nonprod-invoicing='eval $(devx locksmith env-vars -s invoicing-v2 -n 5ccc787a795f940104e5132b -e staging)'

export DOCKER_HOST=unix://${XDG_RUNTIME_DIR}/podman/podman.sock
export TESTCONTAINERS_RYUK_DISABLED=true

complete -C /usr/bin/terraform terraform

export XDG_RUNTIME_DIR=/run/user/1000
export PIPEWIRE_RUNTIME_DIR=/run/user/1000
export PULSE_SERVER=unix:/run/user/1000/pulse/native
export TZ="America/Los_Angeles"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

export PATH="/home/bpayne/IntelliJ/latest/bin:$PATH"

cdrw_jump() {
    local target
    target=$(command cdrw --select)
    if [ -n "$target" ]; then
        cd "$target" || return 1
    fi
}
alias bh='bh history recall'
alias c='cd-rw-52x'
alias cb="flatpak run app.getclipboard.Clipboard"
alias au='sudo apt update && sudo apt upgrade'
alias clcl='click-clop'
alias pmr='print-my-ride'
vhich() {
    vim "$(which "$1")"
}
complete -c vhich
alias j='sudo journalctl -r'
alias jf='sudo journalctl --follow'
alias pc='podman-compose'
source /usr/share/bash-completion/completions/podman-compose
complete -F _podmanCompose pc
psx() {
    ps -eo pid,user,%cpu,%mem,exe:60,cmd --sort=-%mem | head -n "${1:-30}"
}


alias ll='eza -l --git --git-repos'
export TIME_STYLE=iso

alias sound-test='pw-record --channels=1 --rate=48000 /tmp/test.wav; pw-play /tmp/test.wav'
alias pw-test='sound-test'
export PATH=$PATH:$HOME/.maestro/bin
alias vim='nvim'
alias f='vimm-find'

source '/home/bpayne/.bash_completions/hf.sh'

export HF_HOME=/mnt/8cb5669f-0636-4e40-b8d8-0d215a8a6aa5/models/hf-cache/huggingface

# pnpm
export PNPM_HOME="/home/bpayne/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/home/bpayne/google-cloud-sdk/path.bash.inc' ]; then . '/home/bpayne/google-cloud-sdk/path.bash.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/home/bpayne/google-cloud-sdk/completion.bash.inc' ]; then . '/home/bpayne/google-cloud-sdk/completion.bash.inc'; fi
