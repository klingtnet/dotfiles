source .envs
source .aliases

if [ -f "$HOME/.custom" ]; then
    source $HOME/.custom
fi

### history
SAVEHIST=-1
HISTFILE=~/.zsh_history
#setopt appendhistory    # append instead of overwrite
setopt sharehistory     # share history between terminals

### options
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

### TERM
# manually set TERM to get a 256 terminal
# despite some misleading warnings this is no problem: https://bbs.archlinux.org/viewtopic.php?id=178309
local TERMPATH=/lib/terminfo
if [ -e /lib/terminfo/x/xterm-256color ]; then
    export TERM='xterm-256color'
else
    export TERM='xterm-color'
fi
if [ $(tput colors) -ne 256 ]; then
    echo "Couldn't set to 256 color terminal: $TERM!"
fi

# append function search path so promptinit is able to find my theme
[[ -d ~/.zsh/functions ]] && fpath=(~/.zsh/functions $fpath)

### load modules
autoload -U compinit promptinit colors zcalc
if [ $? -eq 0 ]; then
    compinit
    promptinit
    colors
fi

# append ~/bin to path
[[ -f ~/.paths ]] && . ~/.paths
[[ -f ~/.sh_functions ]] && . ~/.sh_functions

# load theme
if [ ! -z "$(prompt -l | grep klingtnet)" ]; then
    prompt klingtnet
else
    echo "Could not find \"klingtnet\" shell prompt theme!"
fi

# vim: set syntax=sh:
