alias git=hub
alias gs='git status -sb'
alias ls="ls -Gp"
alias gitclean="git fetch --prune && git branch -r | awk '{print \$1}' | egrep -v -f /dev/fd/0 <(git branch -vv | grep origin) | awk '{print \$1}' | xargs git branch -d"
alias t='todo.sh'
alias mci="mvn clean install"
