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

	CURRENT_IP=$(ifconfig | grep 'inet ' | grep -v '127.0.0.1' | head -n1 | awk '{ print $2}')
	cat ~/.dotfiles/templates/yggdrasil.properties.autotemplate | sed -e "s/CURRENT_IP/$CURRENT_IP/g" > ~/Dev/Jormungand/jormungand-server/config/yggdrasil.properties
	cat ~/.dotfiles/templates/thor_Config.js.autotemplate | sed -e "s/CURRENT_IP/$CURRENT_IP/g" > ~/Dev/Helga/Client/js/thor/Config.js
	cat ~/.dotfiles/templates/tkthor_Config.js.autotemplate | sed -e "s/CURRENT_IP/$CURRENT_IP/g" > ~/Dev/Helga/Client/js/tkthor/Config.js

	case "$1" in
		"yggdrasil")
			newtab eval "cd ~/Dev/Yggdrasil/yggdrasil-server; java -Xmx128m -Xms32m -jar target/yggdrasil-server-*-jar-with-dependencies.jar"
			;;
		"kellaa")
			newtab eval "cd ~/Dev/Kellaa/kellaa-server; java -Xmx128m -Xms32m -jar target/kellaa-server-*-jar-with-dependencies.jar"
			;;
		"jormungand")
			newtab eval "cd ~/Dev/Jormungand/jormungand-server; java -Xmx128m -Xms32m -jar target/jormungand-server-*-jar-with-dependencies.jar"
			;;
		"services")
			sleep 2
			run yggdrasil
			sleep 2
			run kellaa
			sleep 2
			run jormungand
			;;
		"dh")
			sleep 2
			newtab eval "cd ~/Dev/Helga/Server/dh-server; java -Xmx128m -Xms32m -jar target/darkheroes-server-*-SNAPSHOT-jar-with-dependencies.jar"
			;;
		"dark-heroes-all")
			run services
			run dh
			;;
		"validation-dh")
			eval "cd ~/Dev/Helga/Server/dh-server; java -Xmx128m -Xms32m -jar ~/Dev/Helga/Tools/dh-tools/target/darkheroes-tools-*-SNAPSHOT-jar-with-dependencies.jar validate"
			;;
		"export-dh")
			eval "cd ~/Dev/Helga/Server/dh-server; java -Xmx128m -Xms32m -jar ~/Dev/Helga/Tools/dh-tools/target/darkheroes-tools-*-SNAPSHOT-jar-with-dependencies.jar export -odir $DHC/js/data"
			;;
		"madccg-all")
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
			eval "cd ~/Dev/Yggdrasil; mvn clean install"
			eval "cd ~/Dev/Kellaa; mvn clean install"
			eval "cd ~/Dev/Jormungand; mvn clean install"
			;;
		"dh")
			eval "cd ~/Dev/Helga; mvn clean install"
			;;
		"dark-heroes-all")
			build services
			eval "cd ~/Dev/Helga; mvn clean install"
			;;
		"madccg")
			eval "cd ~/Dev/HelgaMad; mvn clean install"
			;;
	esac
}

# bash completion
function _run()
{
	local cur=${COMP_WORDS[COMP_CWORD]}
	COMPREPLY=( $(compgen -W "yggdrasil kellaa jormungand services dh dark-heroes-all validation-dh export-dh madccg-all" -- $cur) )
}
complete -F _run run

function _build()
{
	local cur=${COMP_WORDS[COMP_CWORD]}
	COMPREPLY=( $(compgen -W "services dark-heroes madccg" -- $cur) )
}
complete -F _build build

[ -s $HOME/.nvm/nvm.sh ] && . $HOME/.nvm/nvm.sh # This loads NVM
