#!/bin/sh

function linkdot() {
	if [ -f ~/.$1 ]; then
		mv ~/.$1 ~/.$1.bak
	fi
	ln -s ~/.dotfiles/$1 ~/.$1
}

linkdot bash_profile
linkdot bashrc
linkdot gitconfig
linkdot vim
linkdot vimrc
linkdot gvimrc
linkdot gvimrc-tiny-kingdom
linkdot git-completion.bash
