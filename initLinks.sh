#!/bin/sh

echo YOU PROBABLY DO NOT WANT TO RUN THIS. FILE KEPT FOR REFERENCE.
exit 1

function initdot() {
	mv .$1 ~/.dotfiles/$1
}

initdot bash_profile
initdot bashrc
initdot gitconfig
initdot vim
initdot vimrc
initdot gvimrc
initdot gvimrc-tiny-kingdom
