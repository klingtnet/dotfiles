#!/bin/bash

patchfile="$HOME/$USER-$HOSTNAME-dotfiles.patch"
dotfiles=( $( cd dots && find -type f -not -path '*/.vim/*' | sed 's/^\.\///') )

show_diff() {
    for dotfile in ${dotfiles[@]}; do
        diff -Naur $PWD/dots/$dotfile $HOME/$dotfile
    done
}

apply_patch() {
    [[ -n "$1" && "$1" != '--dry-run' ]]\
        && echo "Unknown option: $1"\
        && exit 3
    [[ ! -e "$patchfile" ]]\
        && echo "Patch does not exist: $patchfile"\
        && exit
    patch --force --quiet -i "$patchfile" --directory="$HOME" $1
}

case $1 in
    "apply")
        apply_patch $2
        ;;
    "create")
        show_diff > "$patchfile"
        echo "Created patch-file: $patchfile"
        ;;
    "")
        show_diff
        ;;
    *)
        echo "Usage: $0 [create|apply [--dry-run]]"
        exit 1
        ;;
esac
