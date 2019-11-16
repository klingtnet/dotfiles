source $HOME/.envs

SAVEHIST=$HISTSIZE
HISTFILE=~/.zsh_history

setopt append_history    # append instead of overwrite
setopt share_history     # share history between terminals
setopt extended_history  # save commands timestamp

# zsh options
# - names are case insensitive and underscores are ignored
# - `unsetopt foo` is equivalent to `setopt nofoo`
setopt autolist         # list tab completion candidates
setopt automenu         # choose completion candidates
setopt histfindnodups   # do not display duplicate history entries
setopt histverify       # perform history expansion and reload the line in the edit buffer
setopt aliases          # expand aliases
setopt clobber          # allow file truncation and appending with >, respectively >>
setopt checkjobs        # display warning on exit if there are running jobs
setopt rmstarwait       # wait 10 seconds before executing rm *
unsetopt beep           # who the heck needs beeps anyway?

# keybindings
# inspired by http://git.grml.org/?p=grml-etc-core.git;a=blob_plain;f=etc/zsh/zshrc;hb=HEAD

typeset -A key
key=(
    Home     "${terminfo[khome]}"
    End      "${terminfo[kend]}"
    Insert   "${terminfo[kich1]}"
    Delete   "${terminfo[kdch1]}"
    Up       "${terminfo[kcuu1]}"
    Down     "${terminfo[kcud1]}"
    Left     "${terminfo[kcub1]}"
    Right    "${terminfo[kcuf1]}"
    PageUp   "${terminfo[kpp]}"
    PageDown "${terminfo[knp]}"
    BackTab  "${terminfo[kcbt]}"
)

bindkey -e
bindkey "^R"            history-incremental-search-backward
bindkey ${key[Home]}    beginning-of-line
bindkey ${key[End]}     end-of-line
bindkey ${key[Insert]}  overwrite-mode
bindkey ${key[Delete]}  delete-char
bindkey ${key[Left]}    backward-char
bindkey ${key[Right]}   forward-char
bindkey ${key[Up]}      up-line-or-search
bindkey ${key[Down]}    down-line-or-search
bindkey ${key[PageUp]}  history-beginning-search-backward
bindkey ${key[PageDown]} history-beginning-search-forward
bindkey ${key[BackTab]} backward-delete-char
# C-left/C-right xterm
bindkey '\e[1;5C'          forward-word
bindkey '\e[1;5D'          backward-word
bindkey '\[[1;3C'          forward-word
bindkey '\[[1;3D'          backward-word

### load modules
autoload -U compinit colors zcalc &&\
    compinit &&\
    colors

export KN_CMD_START_TIME_NS=$(date +%s%N)
export KN_CMD_END_TIME_NS=$KN_CMD_START_TIME_NS

precmd() {
    local kn_status=$?
    KN_CMD_END_TIME_NS=$(date +%s%N)
    PROMPT="$(CLICOLOR_FORCE=true rusty-prompt $kn_status)"
}

preexec() {
    KN_CMD_START_TIME_NS=$(date +%s%N)
}

# source custom files
source $HOME/.aliases
source $HOME/.paths
[[ -f "$HOME/.$USER" ]] && source "$HOME/.$USER"

# vim: set syntax=sh:
