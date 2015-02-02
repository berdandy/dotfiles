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

# multirunner
function run() {
	if ! [ `type -t newtab` ]; then
		echo "ERROR: newtab() not defined, make sure you have newtab.bash included in your bash_profile"
		return
	fi

	case "$1" in
		"services")
			newtab eval "cd ~/Dev/Yggdrasil/yggdrasil-server; java -Xmx128m -Xms32m -jar target/yggdrasil-server-*-SNAPSHOT-jar-with-dependencies.jar"
			newtab eval "cd ~/Dev/Kellaa/kellaa-server; java -Xmx128m -Xms32m -jar target/kellaa-server-*-SNAPSHOT-jar-with-dependencies.jar"
			newtab eval "cd ~/Dev/Jormungand/jormungand-server; java -Xmx128m -Xms32m -jar target/jormungand-server-*-SNAPSHOT-jar-with-dependencies.jar"
			;;
		"dark-heroes")
			run services
			newtab eval "cd ~/Dev/Helga/Server/dh-server; java -Xmx128m -Xms32m -jar target/madccg-server-*-SNAPSHOT-jar-with-dependencies.jar"
			;;
		"madccg")
			run services
			newtab eval "cd ~/Dev/HelgaMad/Server/dh-server; java -Xmx128m -Xms32m -jar target/madccg-server-*-SNAPSHOT-jar-with-dependencies.jar"
			;;
	esac
}
function build() {
	if ! [ `type -t newtab` ]; then
		echo "ERROR: newtab() not defined, make sure you have newtab.bash included in your bash_profile"
		return
	fi

	case "$1" in
		"services")
			newtab eval "cd ~/Dev/Yggdrasil; mvn clean install"
			newtab eval "cd ~/Dev/Kellaa; mvn clean install"
			newtab eval "cd ~/Dev/Jormungand; mvn clean install"
			;;
		"dark-heroes")
			newtab eval "cd ~/Dev/Helga; mvn clean install"
			;;
		"madccg")
			run services
			newtab eval "cd ~/Dev/HelgaMad; mvn clean install"
			;;
	esac
}

# bash completion
function _run()
{
	local cur=${COMP_WORDS[COMP_CWORD]}
	COMPREPLY=( $(compgen -W "services dark-heroes madccg" -- $cur) )
}
complete -F _run run

function _build()
{
	local cur=${COMP_WORDS[COMP_CWORD]}
	COMPREPLY=( $(compgen -W "services dark-heroes madccg" -- $cur) )
}
complete -F _build build

[ -s $HOME/.nvm/nvm.sh ] && . $HOME/.nvm/nvm.sh # This loads NVM
