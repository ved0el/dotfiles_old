# Enviroment variables
export PATH=$PATH:$GOPATH/bin
export GOBIN=$GOPATH/bin
export GOPATH=$HOME/.go
export PATH=$PATH:$HOME/.dotfiles/bin
export ENHANCD_COMMAND='cd'
export ENHANCD_FILTER="fzy:fzf-tmux:fzf:peco:percol:gof:pick:icepick:sentaku:selecta"
export FZF_DEFAULT_COMMAND="fd --type f"
export FZF_DEFAULT_OPTS="--layout=reverse --inline-info"
# Use color for terminal
autoload -Uz colors
colors
# Add color for 'ls' command
export CLICOLOR=true
# Change color of suggestion
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=243'

# History file
HISTFILE=~/.zsh_history
# Size of history
HISTSIZE=10000
SAVEHIST=10000
# Sharing history with other terminal
setopt share_history
# Do not display duplicated history
setopt histignorealldups
# コマンドを途中まで入力後、historyから絞り込み
# 例 ls まで打ってCtrl+pでlsコマンドをさかのぼる、Ctrl+bで逆順
autoload -Uz history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey "^p" history-beginning-search-backward-end
bindkey "^b" history-beginning-search-forward-end
# Remove unnecessary space before saving to history
setopt hist_reduce_blanks

# Omit 'cd' for directory moving command
setopt auto_cd
# Execute 'ls' commnad after diretory moving
# chpwd() { ls -ltr --color=auto }
# Turn off alert sound
setopt no_beep

# Enable dir color
eval `dircolors $HOME/.dircolors`

# Add color for completion
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
# 補完後、メニュー選択モードになり左右キーで移動が出来る
zstyle ':completion:*:default' menu select=1
# 補完で大文字にもマッチ
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
# sudo の後ろでコマンド名を補完する
zstyle ':completion:*:sudo:*' command-path /usr/local/sbin /usr/local/bin /usr/sbin /usr/bin /sbin $HOME/.dotfiles/bin

# Auto attach and detach tmux when login or logout shell
function is_exists() { type "$1" >/dev/null 2>&1; return $?; }
function is_osx() { [[ $OSTYPE == darwin* ]]; }
function is_screen_running() { [ ! -z "$STY" ]; }
function is_tmux_runnning() { [ ! -z "$TMUX" ]; }
function is_screen_or_tmux_running() { is_screen_running || is_tmux_runnning; }
function shell_has_started_interactively() { [ ! -z "$PS1" ]; }
function is_ssh_running() { [ ! -z "$SSH_CONECTION" ]; }

function tmux_automatically_attach_session()
{
    if is_screen_or_tmux_running; then
        ! is_exists 'tmux' && return 1

        if is_tmux_runnning; then
            echo "${fg_bold[red]} _____ __  __ _   ___  __ ${reset_color}"
            echo "${fg_bold[red]}|_   _|  \/  | | | \ \/ / ${reset_color}"
            echo "${fg_bold[red]}  | | | |\/| | | | |\  /  ${reset_color}"
            echo "${fg_bold[red]}  | | | |  | | |_| |/  \  ${reset_color}"
            echo "${fg_bold[red]}  |_| |_|  |_|\___//_/\_\ ${reset_color}"
        elif is_screen_running; then
            echo "This is on screen."
        fi
    else
        if shell_has_started_interactively && ! is_ssh_running; then
            if ! is_exists 'tmux'; then
                echo 'Error: tmux command not found' 2>&1
                return 1
            fi

            if tmux has-session >/dev/null 2>&1 && tmux list-sessions | grep -qE '.*]$'; then
                # detached session exists
                tmux list-sessions
                echo -n "Tmux: attach? (y/N/num) "
                read
                if [[ "$REPLY" =~ ^[Yy]$ ]] || [[ "$REPLY" == '' ]]; then
                    tmux attach-session
                    if [ $? -eq 0 ]; then
                        echo "$(tmux -V) attached session"
                        return 0
                    fi
                elif [[ "$REPLY" =~ ^[0-9]+$ ]]; then
                    tmux attach -t "$REPLY"
                    if [ $? -eq 0 ]; then
                        echo "$(tmux -V) attached session"
                        return 0
                    fi
                fi
            fi

            if is_osx && is_exists 'reattach-to-user-namespace'; then
                # on OS X force tmux's default command
                # to spawn a shell in the user's namespace
                tmux_config=$(cat $HOME/.tmux.conf <(echo 'set-option -g default-command "reattach-to-user-namespace -l $SHELL"'))
                tmux -f <(echo "$tmux_config") new-session && echo "$(tmux -V) created new session supported OS X"
            else
                tmux new-session && echo "tmux created new session"
            fi
        fi
    fi
}

tmux_automatically_attach_session

if [[ ! -f $HOME/.zinit/bin/zinit.zsh ]]; then
    print -P "%F{33}▓▒░ %F{220}Installing DHARMA Initiative Plugin Manager (zdharma/zinit)…%f"
    command mkdir -p "$HOME/.zinit" && command chmod g-rwX "$HOME/.zinit"
    command git clone https://github.com/zdharma/zinit "$HOME/.zinit/bin" && \
        print -P "%F{33}▓▒░ %F{34}Installation successful.%f%b" || \
        print -P "%F{160}▓▒░ The clone has failed.%f%b"
fi

# Source Zinit
source $HOME/.zinit/bin/zinit.zsh
# Source other config
for f in $HOME/.dotfiles/zsh/*.zsh ;do
    source $f
done
# Zinit plugins with Turbo mode
zinit wait lucid for \
    light-mode  mafredri/zsh-async \
                chrissicool/zsh-256color \
    atinit"ZINIT[COMPINIT_OPTS]=-C; zicompinit; zicdreplay" \
                zdharma/fast-syntax-highlighting \
    blockf \
                zsh-users/zsh-completions \
    atload"!_zsh_autosuggest_start" \
                zsh-users/zsh-autosuggestions

# Theme
#zinit ice compile'(pure|async).zsh' pick'async.zsh' src'pure.zsh'
#zinit light "sindresorhus/pure"
zinit light "denysdovhan/spaceship-zsh-theme"
# # Show time
SPACESHIP_TIME_SHOW=true

# Binary release in archive, from GitHub-releases page.
# After automatic unpacking it provides program "fzf".
zinit ice from"gh-r" as"program"
zinit load junegunn/fzf-bin

# Enhancd plugin
zinit ice \
  atclone'rm -rf conf.d; rm -rf functions; rm -f *.fish;' \
  pick'init.sh' \
  nocompile'!' \
  wait'!0'
zinit light b4b4r07/enhancd

# Sudo plugin (ESC to add sudo to last command)
zinit snippet OMZ::plugins/sudo/sudo.plugin.zsh
