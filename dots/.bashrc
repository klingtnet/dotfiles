# If not running interactively, don't do anything
[[ $- != *i* ]] && return

shopt -s globstar
shopt -s histappend
HISTCONTROL=ignoredups:erasedups:ignorespace
HISTFILESIZE=-1
HISTSIZE=-1
HISTTIMEFORMAT='%s'

export HSTR_CONFIG=hicolor,raw-history-view
# bind hstr to Ctrl-r (for Vi mode check doc)
bind '"\C-r": "\C-a hstr -- \C-j"'
# bind 'kill last command' to Ctrl-x k
bind '"\C-xk": "\C-a hstr -k \C-j"'

# uncomment to enbale vi-keybindings
#set -o vi

# http://bashrcgenerator.com/
prompt_cmd() {
	# append to history
	# the default is to only write to the history when the shell is exited
	history -a
	history -n
    local kn_status=$?
    KN_CMD_END_TIME_NS=$(date +%s%N)
    PS1="$(rusty-prompt $kn_status)"
}
PROMPT_COMMAND=prompt_cmd

# source custom files
source $HOME/.envs
source $HOME/.aliases
source $HOME/.paths
[[ -f "$HOME/.$USER" ]] && source "$HOME/.$USER"

# vim: set syntax=sh:
