if has("gui_macvim")
	" colorscheme solarized
	" command-t
	macmenu File.New\ Tab key=<nop>
	macmenu Edit.Find.Find\.\.\. key=<nop>
	set wildignore+=**/node_modules/**,*.png,*.jpg,*.wav,*.mp3
endif

" source ~/.gvimrc-tiny-kingdom
source ~/.gvimrc-dark-heroes

