NODE_PATH="/usr/local/lib/jsctags:${NODE_PATH}"

##
# Your previous /Users/aberdan/.bash_profile file was backed up as /Users/aberdan/.bash_profile.macports-saved_2013-01-22_at_07:33:17
##

# MacPorts Installer addition on 2013-01-22_at_07:33:17: adding an appropriate PATH variable for use with MacPorts.
export PATH=/opt/local/bin:/opt/local/sbin:$PATH
# Finished adapting your PATH environment variable for use with MacPorts.

if [ -f /opt/local/etc/profile.d/bash_completion.sh ]; then
	. /opt/local/etc/profile.d/bash_completion.sh
fi

export FREYJA=~/Dev/Tiny-Kingdom/server/js/freyja
export TKS=~/Dev/Tiny-Kingdom/server/js/tiny-kingdom
export TKC=~/Dev/Tiny-Kingdom/client/js
export THOR=~/Dev/Tiny-Kingdom/client/js/thor
export TK=~/Dev/Tiny-Kingdom

# tiny kingdom multirunner
function run() {
	case "$1" in
		"folkvangr")
			cd $FREYJA/folkvangr; screen -S folkvangr -DR bash -c 'node app.js run; exec bash -l'
			;;
		"zero")
			cd $FREYJA/zero; screen -S zero -DR bash -c 'node app.js run; exec bash -l'
			;;
		"tiny-kingdom")
			cd $TKS; screen -S tiny-kingdom -DR bash -c 'node app.js run; exec bash -l'
			;;
		*)
			cat > ~/.unifiedRunConfig << EOF
			chdir $FREYJA/folkvangr
			screen bash -c 'node app.js run; exec bash -l'
			split
			focus
			chdir $FREYJA/zero
			screen bash -c 'node app.js run; exec bash -l'
			split
			focus
			chdir $TKS
			screen bash -c 'node app.js run; exec bash -l'
			chdir $TK
EOF
			screen -S unified -DR -c ~/.unifiedRunConfig
			;;
	esac
}

# bash completion
function _run()
{
	local cur=${COMP_WORDS[COMP_CWORD]}
	COMPREPLY=( $(compgen -W "tiny-kingdom folkvangr zero" -- $cur) )
}
complete -F _run run
