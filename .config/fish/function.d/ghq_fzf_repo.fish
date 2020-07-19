function ghq_fzf_repo -d 'Repository search'
  ghq list --full-path | \
  fzf-tmux -d 80%  --reverse --preview 'tree -C {}' \
           --preview-window=:right:60% --bind='?:toggle-preview' | \
  read select
  [ -n "$select" ]; and cd "$select"
  echo " $select "
  commandline -f repaint
end

# fish key bindings
function fish_user_key_bindings
  bind \cg ghq_fzf_repo
end
