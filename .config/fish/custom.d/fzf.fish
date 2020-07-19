set -U FZF_LEGACY_KEYBINDINGS 0
set  FZF_TMUX 1
set  FZF_TMUX_HEIGHT "80%"
set  FZF_TMUX_OPTS "-d 70%"
set -U FZF_PREVIEW_DIR_COMMAND "tree -C {} 2> /dev/null"
set -U FZF_PREVIEW_FILE_COMMAND "bat {} 2> /dev/null"
set -U FZF_PREVIEW_COMMAND "if test -f {}; \
                          $FZF_PREVIEW_FILE_COMMAND; \
                        else if test -d {}; \
                          $FZF_PREVIEW_DIR_COMMAND; \
                        else; \
                          echo {}; \
                        end;"
set -U FZF_DEFAULT_COMMAND "fd --type file --follow --hidden --color=always --exclude .git . $HOME"
set -U FZF_DEFAULT_OPTS "--layout=reverse --inline-info \
                        --preview '$FZF_PREVIEW_COMMAND' \
                        --preview-window=:hidden:right:60% \
                        --bind='?:toggle-preview' \
                        --bind='ctrl-u:preview-page-up' \
                        --bind='ctrl-d:preview-page-down'"
set -U FZF_CTRL_T_COMMAND "$FZF_DEFAULT_COMMAND --select-1 --exit-0"
set -U FZF_ALT_C_COMMAND "fd --type directory --follow --hidden --color=always --exclude .git . $HOME"
set -U FZF_CTRL_R_OPTS "--sort --exact"
