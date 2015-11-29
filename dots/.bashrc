#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

source .envs
source .aliases

if [ -f "$HOME/.custom" ]; then
    source $HOME/.custom
fi

HISTFILESIZE=-1

PS1='[\u@\h \W]\$ '

if [ -d "$HOME/.rvm" ]; then
    export PATH="$PATH:$HOME/.rvm/bin" # Add RVM to PATH for scripting
fi

# uncomment to enbale vi-keybindings
#set -o vi
export PS1="\u@\h-\t} \w \n\$? \\$ \[$(tput sgr0)\]"

# http://bashrcgenerator.com/
prompt_cmd() {
    STATUS=$?
    PS1=""
    if [ $SHLVL -ne 0 ]; then
        PS1+="\[\e[34m\]sub \[\e[0m\]"
    fi
    if [ $EUID -eq 0 ]; then
        PS1+="\[\e[31m\]\u\[\e[0m\]"
    else
        PS1+="\[\e[32m\]\u\[\e[0m\]"
    fi
    PS1+=@
    PS1+="\[\e[33m\]\H\[\e[0m\]"
    if [ $STATUS -ne 0 ]; then
        PS1+=" \[\e[1;31m\]\$?\[\e[0;0m\]"
    fi
    PROMPT+=" in"
    # \w full path
    PS1+=" \[\e[35m\]\W\[\e[0m\]"
    PS1+=" "
}

export -f prompt_cmd

export PROMPT_COMMAND=prompt_cmd

# vim: set syntax=sh: