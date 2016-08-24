export T=~/Dev/ThorCC
export TE=~/Dev/ThorCC-External
export TX=~/Dev/ThorCC-Example
export TT=~/Dev/TripleTap

# export T=~/Dev/Thor
# export TT=~/Dev/tiny-tappers
# export TTA=~/Dev/tiny-tappers-assets
# export K=~/Dev/Kellaa
# export P=~/Dev/ProjectV-Thor
# export DH=~/Dev/Helga
# export DHS=~/Dev/Helga/Server
# export DHDH=~/Dev/Helga/Server/js/dark-heroes
# export DHC=~/Dev/Helga/Client
# export DHA=~/Dev/Helga_Assets
# export M=~/Dev/HelgaMad
# export MS=~/Dev/HelgaMad/Server
# export MM=~/Dev/HelgaMad/Server/js/dark-heroes
# export MC=~/Dev/HelgaMad/Client
# export MA=~/Dev/HelgaMad_Assets

export M2_HOME=/usr/local/apache-maven/apache-maven-3.3.1/
export M2=$M2_HOME/bin
export MAVEN_OPTS="-Xms256m -Xmx512m"
export PATH=$M2:$PATH
export JAVA_HOME=/Library/Java/JavaVirtualMachines/jdk1.8.0_45.jdk/Contents/Home/

set bell-style visible

if [ -f ~/.bash_aliases ]; then
	. ~/.bash_aliases
fi

if [ -f ~/.bash_private ]; then
	. ~/.bash_private
fi

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm
