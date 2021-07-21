# Change the files searched
set fzf_fd_opts --hidden --exclude=.git,.DS_Store

# Change hotkey, see `fzf_configure_bindings --help` for futher infomations.
fzf_configure_bindings --directory=\cf --git_log=\cl --variables


# Force `fzf.fish` using fzf-tmux
function fzf --wraps=fzf --description="Use fzf-tmux if in tmux session"
  if set --query TMUX
    fzf-tmux $argv
  else
    command fzf $argv
  end
end
