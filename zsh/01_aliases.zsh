# Easier navigation: .., ..., ...., ....., ~ and -
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."

# Always enable colored `grep` output
# Note: `GREP_OPTIONS="--color=auto"` is deprecated, hence the alias usage.
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

# Show IP
alias myip="curl inet-ip.info"

# ls 
alias ls="ls --color=always"
alias la="ls -al"
alias zshrc="emacs ~/.zshrc"

# Update
alias sau="sudo apt update && sudo apt upgrade"
alias sap="sudo apt purge"
alias sai="sudo apt install"
alias saa="sudo apt autoremove -y"
alias rmf="sudo rm -rf"
alias acs="apt-cache search"

# git
alias gpl="git pull"
alias gps="git push"
alias gcm="git commit"
alias gch="git checkout"
alias gst="git status"

# Others
alias editalias="emacs ~/.dotfiles/zsh/01_aliases.zsh"
alias reboot="sudo reboot now"
alias evince="google-chrome"
alias chrome="google-chrome"