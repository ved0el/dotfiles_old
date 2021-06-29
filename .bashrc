# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

[[ $- != *i* ]] && return

# History
HISTSIZE=1000
HISTFILESIZE=2000
HISTCONTROL=ignoreboth

# Directory color
if [ $TERM == *-256color ] && [ -f $HOME/.dircolors ]; then
    eval `dircolors $HOME/.dircolors`
fi

# Completion
if [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
fi

# colorful for Terminal
export PS1="\n\[\e[31m\]\u\[\e[m\] \[\e[36m\]in\[\e[m\] \[\e[32m\]\h\[\e[m\] \[\e[36m\]at\[\e[m\] \[\e[33m\]\W\[\e[m\] \n\[\e[35m\][\A]\[\e[m\] \[\e[32m\]$\[\e[m\] "

[ -f ~/.fzf.bash ] && source ~/.fzf.bash
