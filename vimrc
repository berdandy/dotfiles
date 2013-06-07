" indentation rules
set ignorecase
set cindent
set autoindent
set smartindent
set tabstop=4
set shiftwidth=4
set ruler
set smarttab
set nowrap

syntax on

" font/color
set guifont=Monaco\ for\ Powerline:h13
set background=dark
colorscheme koehler

" gui options
set guioptions-=T
set noeb vb t_vb=

" editor options
set nocompatible   " disable vi-compatibility
set laststatus=2   " always show the statusline
set encoding=utf-8

" behaviour
set autochdir

" package manager setup
set rtp+=~/.vim/bundle/vundle
call vundle#rc()
Bundle 'gmarik/vundle'

" installed packages:
Bundle 'wincent/Command-T'
Bundle 'motemen/git-vim'
Bundle 'mattn/zencoding-vim'
Bundle 'pangloss/vim-javascript'
Bundle 'tpope/vim-fugitive'
Bundle 'Lokaltog/vim-powerline'

" set statusline=%<%f\ %h%m%r%{fugitive#statusline()}%=%-14.(%l,%c%V%)\ %P

" jsfl files
au BufRead *.jsfl set filetype=javascript

" package manager setup
filetype plugin indent on

" powerline options
let g:Powerline_symbols = 'fancy'
let g:Powerline_colorscheme = 'solarized256'

" shortcuts
noremap <F3> :set hlsearch!<CR>
noremap <F5> :CommandTFlush<CR>
noremap <F7> :g/\s\+\w\+\s*:\s*function/p<CR>

" indent and dedent
vmap <D-[> <gv
vmap <D-]> >gv

command -nargs=+ TKSearch vimgrep <args> $TK/**/*.js

" grep/ack
set grepprg=ack-5.12
