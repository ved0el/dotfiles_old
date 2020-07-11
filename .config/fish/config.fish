set CUSTOM_PATH "$__fish_config_dir/custom.d"
set CUSTOM_FUNC "$__fish_config_dir/function.d"


# Confign for Golang
export GOPATH=$HOME/.go
export GOBIN=$GOPATH/bin

# Add user paths
set -U fish_user_paths $HOME/.dotfiles/bin $GOPATH/bin $fish_user_paths

# Enable clock for spacefish theme
set SPACEFISH_TIME_SHOW true

# Enable dircolors
eval "dircolors $HOME/.dircolors >/dev/null 2>&1"

# Load custom configs, functions
for file in $CUSTOM_PATH/* $CUSTOM_FUNC/*
  source $file
end

# Auto attach tmux when fish started
function attach_tmux_session_if_needed
    set ID (tmux list-sessions)
    if test -z "$ID"
        tmux new-session
        return
    end

    set new_session "Create New Session"
    set ID (echo $ID\n$new_session | fzf-tmux | cut -d: -f1)
    if test "$ID" = "$new_session"
        tmux new-session
    else if test -n "$ID"
        tmux attach-session -t "$ID"
    end
end

if status is-interactive
    and not set -q TMUX
    eval attach_tmux_session_if_needed
end
