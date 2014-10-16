export FREYJA=~/Dev/Tiny-Kingdom/server/js/freyja

export DH=~/Dev/Helga
export DHS=~/Dev/Helga/Server
export DHDH=~/Dev/Helga/Server/js/dark-heroes
export DHC=~/Dev/Helga/Client
export DHA=~/Dev/Helga_Assets

export M=~/Dev/HelgaMad
export MS=~/Dev/HelgaMad/Server
export MM=~/Dev/HelgaMad/Server/js/dark-heroes
export MC=~/Dev/HelgaMad/Client
export MA=~/Dev/HelgaMad_Assets

export M2_HOME=/usr/local/apache-maven-3.2.2/
export M2=$M2_HOME/bin
export MAVEN_OPTS="-Xms256m -Xmx512m"
export PATH=$M2:$PATH
export JAVA_HOME=/Library/Java/JavaVirtualMachines/jdk1.8.0_05.jdk/Contents/Home/

if [ -f ~/.bash_aliases ]; then
	. ~/.bash_aliases
fi

if [ -f ~/.bash_private ]; then
	. ~/.bash_private
fi
