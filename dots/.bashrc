# If not running interactively, don't do anything
[[ $- != *i* ]] && return

shopt -s histappend
HISTCONTROL=ignoredups:erasedups
HISTFILESIZE=-1

# uncomment to enbale vi-keybindings
#set -o vi

# http://bashrcgenerator.com/
prompt_cmd() {
    local kn_status=$?
    KN_CMD_END_TIME_NS=$(date +%s%N)
    PS1="$(rusty-prompt $kn_status)"
}
PROMPT_COMMAND=prompt_cmd

# source custom files
source $HOME/.envs
source $HOME/.aliases
source $HOME/.paths
[[ -f ".$USER" ]] && source "$HOME/.$USER"

# vim: set syntax=sh:
