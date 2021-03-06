" -*- mode: VimL; -*-
" klingt.net vimrc
"
" Andreas Linz
" www.klingt.net

""" `:options` and `:h foo` for details
so ~/.vim_vundle

""" misc
set noeb                    " no errorbells
set vb                      " no sound
set autoread                " reload files that are chaged outside vim (is this always good?)
set nocompatible            " no vi compatibility
set ul=1000                 " undolevels
set hi=1000                 " command history
set fsync                   " force sync to disk after file write
set enc=utf-8
"set mouse=a
set nu                      " linenumbers
set list                    " display trailing tabs and spaces
set lcs=tab:\ \ ,trail:·    " list chars
filetype on                 " enable filetypes
filetype plugin on          " load plugin for filetype
filetype indent off         " load filetype specific indent file

if &term =~ '256color'
    set t_ut=
endif

""" http://vimcolors.com/
" DARK
" flatcolor, mopkai, molokai, Monokai
" LIGHT
" github, beauty256, coda, PaperColor

colorscheme flatcolor
syntax on                   " switch syntax highlighting on

""" indentation
set wrap
set lbr                     " wrap long lines at 'breakat' characters
set sbr=¬                   " prefix for wrapped lines
set ts=4                    " tabstop width
set sw=4                    " number of spaces used for every (auto)indent
set sta                     " a <Tab> in an indent inserts `sw` spaces
set si                      " do clever autoindenting

" set highlighting for md files (md are normally modula files)
autocmd BufNew,BufNewFile,BufRead *.md setlocal ft=markdown

if has('gui_running')
    " gvim settings
    set guifont=Fantasque\ Sans\ Mono\ 12
    " disable annoying cursor blinking
    set guicursor+=a:blinkon0
endif

if has('nvim')
    " remap Esc to exit terminal emulator mode
    tnoremap <Esc> <C-\><C-n>
endif

