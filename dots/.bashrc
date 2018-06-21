# terminix https://github.com/gnunn1/terminix/wiki/VTE-Configuration-Issue
[[ -f /etc/profile.d/vte.sh ]] && source /etc/profile.d/vte.sh


# If not running interactively, don't do anything
[[ $- != *i* ]] && return

HISTFILESIZE=-1

# uncomment to enbale vi-keybindings
#set -o vi

# http://bashrcgenerator.com/
prompt_cmd() {
    PS1="$(rusty-prompt $?)"
}

export -f prompt_cmd

export PROMPT_COMMAND=prompt_cmd

# source custom files
source $HOME/.envs
source $HOME/.aliases
source $HOME/.paths
[[ -f ".$USER" ]] && source "$HOME/.$USER"

# vim: set syntax=sh:
