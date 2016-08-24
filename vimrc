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
set tags=./tags,tags,~/Dev/tags

syntax on

" font/color
set guifont=Monaco\ for\ Powerline:h13
set background=dark
set listchars=eol:$,tab:>-,trail:~,extends:>,precedes:<
colorscheme koehler

highlight SignColumn guibg=black
highlight GitGutterAdd ctermfg=2 ctermbg=8 guifg=#009900 guibg=black
highlight GitGutterChange ctermfg=3 ctermbg=8 guifg=#bbbb00 guibg=black
highlight GitGutterDelete ctermfg=1 ctermbg=8 guifg=#ff2222 guibg=black
highlight GitGutterChangeDelete ctermfg=3 ctermbg=8 guifg=#bbbb00 guibg=black

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
Bundle 'Lokaltog/vim-powerline'
Bundle 'berdandy/AnsiEsc.vim'
Bundle 'mileszs/ack.vim'
Bundle 'motemen/git-vim'
Bundle 'tpope/vim-fugitive'
Plugin 'airblade/vim-gitgutter'

" Disable old javascripty plugins
" Bundle 'kien/ctrlp.vim'
" Bundle 'mattn/emmet-vim'
" Bundle 'pangloss/vim-javascript'

" set statusline=%<%f\ %h%m%r%{fugitive#statusline()}%=%-14.(%l,%c%V%)\ %P

" jsfl files
au BufRead *.jsfl set filetype=javascript

" package manager setup
filetype plugin indent on

" powerline options
let g:Powerline_symbols = 'fancy'
let g:Powerline_colorscheme = 'solarized256'

" shortcuts
noremap <F2> :Ack <cword><CR>
noremap <F3> :set hlsearch!<CR>
noremap <F5> :CommandTFlush<CR>
noremap <F6> :g/\s\+\w\+\s*:\s*function/p<CR>

" indent and dedent
vmap <D-[> <gv
vmap <D-]> >gv

" disable middle click pasting
map <MiddleMouse> <Nop>
imap <MiddleMouse> <Nop>

" grep/ack
set grepprg=ack-5.12
let g:ackprg = 'ag --nogroup --nocolor --column'

if executable('ag')
	let g:ctrlp_user_command = 'ag %s -i --nocolor --nogroup --hidden
		  \ --ignore .git
		  \ --ignore .svn
		  \ --ignore .hg
		  \ --ignore .DS_Store
		  \ --ignore "**/*.pyc"
		  \ --ignore "**/target/**"
		  \ --ignore "*.meta"
		  \ -g ""'
endif

com! FormatJSON %!json_reformat
