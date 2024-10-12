# Shell Design
PS1='\n\[\e[38;5;112m\]\u\[\e[0m\] @ \[\e[38;5;135m\]\h\[\e[0m\] \[\e[38;5;178m\]$(git branch 2>/dev/null | grep "*" | sed "s/* //")\[\e[0m\] \[\e[38;5;204m\]$(git status --porcelain 2>/dev/null | grep -q . && echo "* " || echo)\[\e[0m\]\[\e[38;5;117m\]\w\[\e[0m\]\n\[\e[38;5;204m\]\$\[\e[0m\] '

eval "`dircolors`"
export TERM=xterm-256color
export LS_OPTIONS='--color=auto'
BACK_KEY=\#

# Aliases
alias ls='ls $LS_OPTIONS'
alias d="ls -ahls --group-directories-first"
alias $BACK_KEY='cd .. && d'
alias c="clear"
alias q="exit"
alias reboot='systemctl reboot'
alias poweroff='systemctl poweroff'
alias bb='vim ~/.bashrc'
alias pm='/root/powermode.sh' #Proxmox!

# Startup Commands
cd ~
