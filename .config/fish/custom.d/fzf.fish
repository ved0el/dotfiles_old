set -Ux FZF_COMPLETION_TRIGGER '**'
set -Ux FZF_TMUX 1
set -Ux FZF_TMUX_OPTS "-h 80% -d 70%"
set -Ux FZF_PREVIEW_DIR_CMD "tree -C {} 2> /dev/null"
set -Ux FZF_PREVIEW_FILE_CMD "bat {} 2> /dev/null"
set -Ux FZF_PREVIEW_CMD "if test -f {}; \
                          $FZF_PREVIEW_FILE_CMD; \
                        else if test -d {}; \
                          $FZF_PREVIEW_DIR_CMD; \
                        else; \
                          echo {}; \
                        end; "
set -Ux FZF_DEFAULT_CMD "fd --type file --follow --hidden --color=always --exclude .git $HOME"
set -Ux FZF_DEFAULT_OPTS "--ansi \
                          --preview '$FZF_PREVIEW_CMD' \
                          --preview-window=:hidden:right:50% \
                          --bind='?:toggle-preview' \
                          --bind='ctrl-u:preview-page-up' \
                          --bind='ctrl-d:preview-page-down'"
set -Ux FZF_CTRL_T_COMMAND "$FZF_DEFAULT_COMMAND --select-1 --exit-0"
set -Ux FZF_ALT_C_CMD "fd --type directory --follow --hidden $HOME"
set -Ux FZF_CTRL_R_OPTS "--sort --exact"
