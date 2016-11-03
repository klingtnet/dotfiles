#!/bin/bash

[ $(hash nvim) ] &&
    echo "Creating symlinks to setup the neovim configuration ..."
    [ ! -f "$HOME/.vim/init.vim" ] &&
        ln -s $HOME/.vimrc $HOME/.vim/init.vim
    [ ! -f "$HOME/.vim/ginit.vim" ] &&
        ln -s $HOME/.ginit.vim $HOME/.vim/ginit.vim
    [ ! -d "$HOME/.config/nvim" ] &&
        ln -s $HOME/.vim $HOME/.config/nvim
# reset possible error value if nvim wasn't found
echo $? > /dev/null
