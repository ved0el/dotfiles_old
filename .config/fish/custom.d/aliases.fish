# cd
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."

# grep
alias grep="grep --color=auto"
alias fgrep="fgrep --color=auto"
alias egrep="egrep --color=auto"

# history
alias history="history | fzf"

# ls
alias ls="lsd"
alias l="ls -l"
alias la="ls -a"
alias lla="ls -la"
alias lt="ls --tree"

# remove
alias rmf="sudo rm -rfi"

# yay
alias yi="yay -S"
alias yr="yay -Rs"
alias ys="yay -Ss"
alias yu="yay -Syu"
alias yar="yay -Qdtq | yay -Rs -"
alias ysi="yay -Si"
alias yrm="yay -Scc"
alias yli="yay -Qqe"

# apt
alias sau="sudo apt-fast update && sudo apt-fast upgrade"
alias sap="sudo apt-fast purge"
alias sai="sudo apt-fast install"
alias saa="sudo apt-fast autoremove -y"
alias acs="apt-cache search"

# git
alias gpl="git pull"
alias gps="git push"
alias gcm="git commit"
alias gch="git checkout"
alias gst="git status"

# top
alias top="htop"

# Others
alias reboot="sudo reboot now"
alias shutdown="sudo shutdown"
alias editalias="code ~/.dotfiles/zsh/01_aliases.zsh"
alias zshrc="code ~/.zshrc"
alias tmuxconf="code ~/.tmux.conf"

# Show IP
alias publicIP="curl inet-ip.info"
alias localIP="ifconfig | grep 'inet ' | sed -e 's/^.*inet //' -e 's/ .*//'"
