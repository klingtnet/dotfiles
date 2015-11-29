source .envs
source .aliases
source .paths

SAVEHIST=-1
HISTFILE=~/.zsh_history

#setopt appendhistory    # append instead of overwrite
setopt sharehistory     # share history between terminals

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

# append function search path so promptinit is able to find my theme
[[ -d ~/.zsh/functions ]] && fpath=(~/.zsh/functions $fpath)

### load modules
autoload -U compinit promptinit colors zcalc &&\
    compinit &&\
    promptinit &&\
    colors

kn_prompt() {
    STATUS=$?
    PROMPT=""
    if [ $SHLVL -ne 0 ]; then
        PROMPT+="%6Fsub %0f"
    fi
    if [ $EUID -eq 0 ]; then
        PROMPT+="%1F%n%0f"
    else
        PROMPT+="%2F%n%0f"
    fi
    PROMPT+=@
    PROMPT+='%3F%M%0f'
    if [ $STATUS -ne 0 ]; then
        PROMPT+=" %B%1F$?%0f%b"
    fi
    PROMPT+=" in"
    # \w full path
    PROMPT+=" %5F%2d%0f "
}

precmd() {
    kn_prompt;
}

# vim: set syntax=sh:
