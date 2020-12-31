# Add user paths
set -U fish_user_paths /opt/homebrew/bin /opt/homebrew/sbin /opt/local/bin /usr/bin /bin /usr/sbin /sbin
set -U fish_user_paths $PYENV_ROOT/bin $GOBIN $DOTFILE/bin $HOME/.cargo/bin $HOME/.nvm $fish_user_paths
set -x TERM xterm-256color
set -U PYENV_ROOT $HOME/.pyenvs
