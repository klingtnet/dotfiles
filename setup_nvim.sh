#!/bin/bash

[ $(hash nvim) ] &&\
    echo "Creating symlinks to setup the neovim configuration ..."
    [ ! -f "$HOME/.config/init.vim" ] &&\
        ln -s $HOME/.vimrc $HOME/.vim/init.vim
    [ ! -d "$HOME/.config/nvim" ] &&\
        ln -s $HOME/.vim $HOME/.config/nvim
