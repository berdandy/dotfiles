#!/bin/sh

function linkdot() {
	# if it's not already a symlink, but does exist
	if ! [ -L ~/.$1 ] && [ -f ~/.$1 ]; then
		# a new file for dotfiles?
		if ! [ -f ~/.dotfiles/$1 ]; then
			echo "Copying new $1 to .dotfiles"
			cp ~/.$1 ~/.dotfiles/$1
		fi

		echo "Backing up old $1 to $1.bak"
		mv ~/.$1 ~/.$1.bak
	fi

	if ! [ -L ~/.$1 ]; then
		ln -s ~/.dotfiles/$1 ~/.$1
	fi
}

linkdot bash_aliases
linkdot bash_profile
linkdot bashrc
linkdot gitconfig
linkdot vim
linkdot vimrc
linkdot gvimrc
linkdot gvimrc-tiny-kingdom
linkdot gvimrc-dark-heroes
linkdot git-completion.bash
linkdot newtab.bash
linkdot git.commit.template

echo 'You may want to run the following:'
echo '  In Vim: :PluginInstall'
echo '  In bash: vim +PluginInstall +qall'
