# Easier navigation: .., ..., ...., ....., ~ and -
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."

# Always enable colored "grep" output
alias grep="grep --color=auto"
alias fgrep="fgrep --color=auto"
alias egrep="egrep --color=auto"

# Show IP
alias publicIP="curl inet-ip.info"
alias localIP="ifconfig | grep 'inet ' | sed -e 's/^.*inet //' -e 's/ .*//'"

# ls
alias ls="lsd"
alias l="ls -l"
alias la="ls -a"
alias lla="ls -la"
alias lt="ls --tree"

# Apt
alias sau="sudo apt-fast update && sudo apt-fast upgrade"
alias sap="sudo apt-fast purge"
alias sai="sudo apt-fast install"
alias saa="sudo apt-fast autoremove -y"
alias rmf="sudo rm -rf"
alias acs="apt-cache search"

# git
alias gpl="git pull"
alias gps="git push"
alias gcm="git commit"
alias gch="git checkout"
alias gst="git status"

# Others
alias reboot="sudo reboot now"
alias shutdown="sudo shutdown"
alias editalias="code ~/.dotfiles/zsh/01_aliases.zsh"
alias zshrc="code ~/.zshrc"
alias tmuxconf="code ~/.tmux.conf"
alias top="htop"
