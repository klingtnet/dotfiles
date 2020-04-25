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

" change status line color in insert mode
autocmd InsertEnter * highlight StatusLine ctermbg=red
autocmd InsertEnter * highlight StatusLine guibg=red
autocmd InsertLeave * highlight StatusLine ctermbg=lightblue
autocmd InsertLeave * highlight StatusLine guibg=lightblue

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

" disable annoying session save dialog
let g:session_autosave = 'no'
let g:session_autoload = 'no'

" vim-racer
" make sure that `racer` is in your PATH
" and that the rust source is installed.
" Switchting between different rust sources
" is currently not supported by rustup.
let g:racer_cmd = "racer"
let $RUST_SRC_PATH = "/usr/src/rust/src"

if has('gui_running')
    " gvim settings
    set guifont=Fantasque\ Sans\ Mono\ 12
    " disable annoying cursor blinking
    set guicursor+=a:blinkon0
endif

" vim-pandoc (syntax only)
augroup pandoc_syntax
	au! BufNewFile,BufFilePRe,BufRead *.pandoc set filetype=markdown.pandoc
augroup END

if has('nvim')
    " remap Esc to exit terminal emulator mode
    tnoremap <Esc> <C-\><C-n>
endif

if executable('rg')
    let g:grepprg = 'rg --vimgrep --no-heading'
endif
nmap <Leader>b :Buffers<CR>
nmap <Leader>f :Files<CR>
