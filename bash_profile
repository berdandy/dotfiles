NODE_PATH="/usr/local/lib/jsctags:${NODE_PATH}"

##
# Your previous /Users/aberdan/.bash_profile file was backed up as /Users/aberdan/.bash_profile.macports-saved_2013-01-22_at_07:33:17
##

# MacPorts Installer addition on 2013-01-22_at_07:33:17: adding an appropriate PATH variable for use with MacPorts.
export PATH=/opt/local/bin:/opt/local/sbin:$PATH
# Finished adapting your PATH environment variable for use with MacPorts.

if [ -f ~/.bashrc ]; then
	. ~/.bashrc
fi

if [ -f /opt/local/etc/profile.d/bash_completion.sh ]; then
	. /opt/local/etc/profile.d/bash_completion.sh
fi

if [ -f ~/.git-completion.bash ]; then
	. ~/.git-completion.bash
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
		"folkvangr")
			newtab eval "cd $FREYJA/folkvangr ; node app.js run"
			;;
		"zero")
			newtab eval "cd $FREYJA/zero ; node app.js run"
			;;
		"tiny-kingdom")
			newtab eval "cd $TKS ; node app.js run"
			;;
		*)
			newtab eval "cd $FREYJA/folkvangr ; node app.js run"
			newtab eval "cd $FREYJA/zero ; node app.js run"
			newtab eval "cd $TKS ; node app.js run"
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
