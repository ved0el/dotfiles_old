# Enviroment setup for Go lang
export GOROOT=/usr/local/go
export PATH=$PATH:$GOROOT/bin
export GOBIN=$GOROOT/bin
# PATH for some owned script
export PATH=$PATH:$HOME/.dotfiles/bin

# Use color for terminal
autoload -Uz colors
colors
# Add color for 'ls' command
export CLICOLOR=true
# Add color for completion
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
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
chpwd() { ls -ltr --color=auto }
# Turn off alert sound
setopt no_beep
# Checking command spell
#setopt correct

## Auto attach and detach tmux when login or logout shell
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
            echo "${fg_bold[red]} _____ __  __ _   ___  __     _    ____ _____ _____     _______ ____    _ ${reset_color}"
            echo "${fg_bold[red]}|_   _|  \/  | | | \ \/ /    / \  / ___|_   _|_ _\ \   / / ____|  _ \  | |${reset_color}"
            echo "${fg_bold[red]}  | | | |\/| | | | |\  /    / _ \| |     | |  | | \ \ / /|  _| | | | | | |${reset_color}"
            echo "${fg_bold[red]}  | | | |  | | |_| |/  \   / ___ \ |___  | |  | |  \ V / | |___| |_| | |_|${reset_color}"
            echo "${fg_bold[red]}  |_| |_|  |_|\___//_/\_\ /_/   \_\____| |_| |___|  \_/  |_____|____/  (_)${reset_color}"
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

## エイリアス ##
source ~/.dotfiles/zsh/*.zsh

### Added by Zinit's installer
if [[ ! -f $HOME/.zinit/bin/zinit.zsh ]]; then
    print -P "%F{33}▓▒░ %F{220}Installing DHARMA Initiative Plugin Manager (zdharma/zinit)…%f"
    command mkdir -p "$HOME/.zinit" && command chmod g-rwX "$HOME/.zinit"
    command git clone https://github.com/zdharma/zinit "$HOME/.zinit/bin" && \
        print -P "%F{33}▓▒░ %F{34}Installation successful.%f%b" || \
        print -P "%F{160}▓▒░ The clone has failed.%f%b"
fi

source "$HOME/.zinit/bin/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit
### End of Zinit's installer chunk

# Zinit plugins
# zinit light "mafredri/zsh-async"
# # rename tmux windows base on git branch name
# zinit light 'sei40kr/zsh-tmux-rename'
# # 作業ディレクトリに .env ファイルがあった場合に自動的にロードしてくれます。
# zinit snippet 'OMZ::plugins/dotenv/dotenv.plugin.zsh'
# # エイリアスは重宝するものが多く、Gitを使うユーザーには必ずオススメしたいプラグインです。
# # fzf command-line fuzzy finder
# zinit ice from"gh-r" as"program"; zinit load junegunn/fzf-bin
# # Speed up dir change
# zinit light "b4b4r07/enhancd"
# # Highlight syntax
# zinit ice wait'1' atload'_zsh_highlight'
# zinit light 'zdharma/fast-syntax-highlighting'
# # ZSH auto-suggest
# zinit ice wait'1' atload'_zsh_autosuggest_start'
# zinit light 'zsh-users/zsh-autosuggestions'
# # ZSH completion
# zinit ice wait'!0'; zinit load zsh-users/zsh-completions
# # Default 256bit terminal
# zinit light "chrissicool/zsh-256color"
# sudo plugin (ESC to add sudo to last command)
# # zinit snippet"OMZ::plugins/sudo/sudo.plugin.zsh"
# # Web-search plugin (type google[firefox]  [search-phrase])
# zinit snippet 'OMZ::plugins/web-search/web-search.plugin.zsh'
# # sudo plugin
# zinit snippet 'OMZ::plugins/sudo/sudo.plugin.zsh'
# # Spaceship theme
# zinit ice pick'spaceship.zsh' wait'!0'
# zinit light 'denysdovhan/spaceship-zsh-theme'
# zinit ice as"completion"
# zinit snippet https://github.com/zsh-users/zsh-completions/blob/master/src/_setcap
# 補完関係 ##
# autoload -Uz compinit
# compinit
# # 補完後、メニュー選択モードになり左右キーで移動が出来る
# zstyle ':completion:*:default' menu select=1
# # 補完で大文字にもマッチ
# zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
# # sudo の後ろでコマンド名を補完する
# # zstyle ':completion:*:sudo:*' command-path /usr/local/sbin /usr/local/bin /usr/sbin /usr/bin /sbin /bin /usr/X11R6/bin
