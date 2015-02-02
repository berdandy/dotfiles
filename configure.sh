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
linkdot vimrc
linkdot gvimrc
linkdot gvimrc-madccg
linkdot gvimrc-dark-heroes
linkdot git-completion.bash
linkdot newtab.bash
linkdot git.commit.template
linkdot todo

echo 'You may want to run the following in bash:'
echo '  git clone https://github.com/gmarik/Vundle.vim.git ~/.vim/bundle/vundle'
echo '  vim +PluginInstall +qall'
echo '  cd ~/.vim/bundle/command-t/ruby/command-t; ruby extconf.rb; make'
echo '  curl -o /usr/local/bin/git-open https://raw.githubusercontent.com/paulirish/git-open/master/git-open'
