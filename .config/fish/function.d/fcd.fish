# function fcd -d "cd to directory using fzf"
#   fd --type directory --follow --hidden . $HOME | \
#   fzf-tmux -d 80% --reverse --preview 'tree -C {}' \
#            --preview-window=:right:60% --bind='?:toggle-preview' | \
#   read select
#   [ -n "$select" ]; and cd "$select"
#   echo " $select "
#   commandline -f repaint
# end
