#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

source $HOME/.envs
source $HOME/.aliases
source $HOME/.paths
[[ -f ".$USER" ]] && source "$HOME/.$USER"

HISTFILESIZE=-1

# uncomment to enbale vi-keybindings
#set -o vi

# http://bashrcgenerator.com/
prompt_cmd() {
    STATUS=$?
    PS1=""
    if [ -n "$(jobs)" ]; then
        PS1+="j\\[\e[34m\]\j\[\e[0m\] "
    fi
    if [ $SHLVL -gt 1 ]; then
        PS1+="s\[\e[34m\]${SHLVL}\[\e[0m\] "
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
    PS1+=" \w"
    PS1+=": "
}

export -f prompt_cmd

export PROMPT_COMMAND=prompt_cmd

# vim: set syntax=sh:
