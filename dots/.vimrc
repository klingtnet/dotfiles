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

""" theme
""" http://vimcolors.com/
set t_Co=256
set bg=dark
" DARK
" lucius, gruvbox, flatcolor, mopkai, desertEx, flatui,
" radicalgoodspeed, lxvc, 256-grayvim, bvemu, campfire, ChasingLogic, miko,
" molokai, Monokai, sandydune
" LIGHT
" github, beauty256, gravity, coda, materialbox, morning, nuvola, osx_like,
" PaperColor, parsec, pencil, professional, proton
colorscheme PaperColor
syntax on                   " switch syntax highlighting on

""" indentation
set wrap
set lbr                     " wrap long lines at 'breakat' characters
set sbr=¬                   " prefix for wrapped lines
set ts=4                    " tabstop width
set sw=4                    " number of spaces used for every (auto)indent
set sta                     " a <Tab> in an indent inserts `sw` spaces
set et                      " convert tab to spaces
set si                      " do clever autoindenting

""" statusline
set ls=2                    " use statusline
set stl =                   " reset stl
set stl +=%F                " full path
set stl +=\ %y              " filetype
set stl +=\ %{&ff}          " fileformat
set stl +=\ %{&fenc}        " file encoding
set stl +=\ %m              " modified flag

set stl +=·%=·\           " %= right justify

set stl +=buf(%n)           " buffer number
set stl +=\ 
set stl +=row(%l            " current line
set stl +=/%L)              " total lines
set stl +=\ 
set stl +=col(%v)           " virtual column number
set stl +=\ 
set stl +=%r                " readonly

" set highlighting for md files (md are normally modula files)
autocmd BufNew,BufNewFile,BufRead *.md setlocal ft=markdown

" disable tab expansion in Makefiles
autocmd Filetype make set noexpandtab

" fix slow save in go files, details:
" https://github.com/fatih/vim-go/issues/144#issuecomment-59598099
let g:syntastic_go_checkers = ['golint', 'govet', 'errcheck']
let g:go_highlight_functions = 1
let g:go_highlight_methods = 1
let g:go_highlight_structs = 1
let g:go_highlight_interfaces = 1
let g:go_highlight_operators = 1
let g:go_highlight_build_constraints = 1

" gvim settings
set guifont=Hack\ 10

if has('nvim')
    " remap Esc to exit terminal emulator mode
    tnoremap <Esc> <C-\><C-n>
endif
