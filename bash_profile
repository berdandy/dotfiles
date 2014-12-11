NODE_PATH="/usr/local/lib/jsctags:${NODE_PATH}"

##
# Your previous /Users/aberdan/.bash_profile file was backed up as /Users/aberdan/.bash_profile.macports-saved_2013-01-22_at_07:33:17
##

# MacPorts Installer addition on 2013-01-22_at_07:33:17: adding an appropriate PATH variable for use with MacPorts.
export PATH=/opt/local/bin:/opt/local/sbin:$PATH:/Applications/MAMP/Library/bin
# Finished adapting your PATH environment variable for use with MacPorts.

# For todo.txt scripts
export PATH=~/.todo:$PATH

if [ -f ~/.bashrc ]; then
	. ~/.bashrc
fi

if [ -f /opt/local/etc/profile.d/bash_completion.sh ]; then
	. /opt/local/etc/profile.d/bash_completion.sh
fi

if [ -f ~/.git-completion.bash ]; then
	. ~/.git-completion.bash
fi

if [ -f ~/.todo/todo_completion ]; then
	. ~/.todo/todo_completion
fi

if [ -f ~/.newtab.bash ]; then
	. ~/.newtab.bash
fi

# tiny kingdom multirunner
#   requires FREYJA, TKS env vars
function run() {
	if ! [ `type -t newtab` ]; then
		echo "ERROR: newtab() not defined, make sure you have newtab.bash included in your bash_profile"
		return
	fi

	case "$1" in
		"dark-heroes")
			newtab eval "cd $DH/Server/js/dark-heroes; java -jar darkheroes-server-jar-with-dependencies.jar"
			;;
		"madccg")
			newtab eval "cd ~/Dev/Yggdrasil/yggdrasil-server/target; java -Xmx128m -Xms32m -jar yggdrasil-server-*-SNAPSHOT-jar-with-dependencies.jar"
			newtab eval "cd ~/Dev/Kellaa/kellaa-server/target; java -Xmx128m -Xms32m -jar kellaa-server-*-SNAPSHOT-jar-with-dependencies.jar"
			newtab eval "cd ~/Dev/Jormungand/jormungand-server/target; java -Xmx128m -Xms32m -jar jormungand-server-*-SNAPSHOT-jar-with-dependencies.jar"
			newtab eval "cd $MM; java -jar darkheroes-server-jar-with-dependencies.jar"
			;;
	esac
}

# bash completion
function _run()
{
	local cur=${COMP_WORDS[COMP_CWORD]}
	COMPREPLY=( $(compgen -W "dark-heroes madccg" -- $cur) )
}
complete -F _run run

[ -s $HOME/.nvm/nvm.sh ] && . $HOME/.nvm/nvm.sh # This loads NVM
