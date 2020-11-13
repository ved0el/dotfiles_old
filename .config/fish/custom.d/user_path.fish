# Add user paths
set -U fish_user_paths $fish_user_paths $GOBIN $DOTFILE/bin (yarn global bin)
set -x TERM xterm-256color
