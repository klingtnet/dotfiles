#!/bin/bash

[ $(hash nvim &>/dev/null) ] &&
    echo "Creating symlinks to setup the neovim configuration ..."
    [ ! -L "$HOME/.vim/init.vim" ] &&
        ln -s $HOME/.vimrc $HOME/.vim/init.vim
    [ ! -L "$HOME/.vim/ginit.vim" ] &&
        ln -s $HOME/.ginit.vim $HOME/.vim/ginit.vim
    [ ! -L "$HOME/.config/nvim" ] &&
        ln -s $HOME/.vim $HOME/.config/nvim
# reset possible error value if nvim wasn't found
echo $? > /dev/null
