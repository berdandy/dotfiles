if has("gui_macvim")
	" colorscheme solarized
	" command-t
	macmenu File.New\ Tab key=<nop>
	macmenu Edit.Find.Find\.\.\. key=<nop>
	set wildignore+=**/node_modules/**,*.png,*.jpg,*.wav,*.mp3
endif

" set up override menu
menu Tools.-EnvSeperator- :
menu Tools.Use\ MADCW\ Environment :source ~/.gvimrc-madccg<CR>
menu Tools.Use\ DH\ Environment :source ~/.gvimrc-dark-heroes<CR>

" default below
" source ~/.gvimrc-dark-heroes
source ~/.gvimrc-madccg

