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

HISTSIZE=16384
HISTFILESIZE=-1

alias ls='ls --color=auto'
PS1='[\u@\h \W]\$ '

if [ -d "$HOME/.rvm" ]; then
    export PATH="$PATH:$HOME/.rvm/bin" # Add RVM to PATH for scripting
fi

# uncomment to enbale vi-keybindings
#set -o vi
export PS1="\u@\h-\t} \w \n\$? \\$ \[$(tput sgr0)\]"

# vim: set syntax=sh:
