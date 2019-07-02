## グローバル減数
# GO lang
# for go lang
export GOROOT=/usr/local/go
export PATH=$PATH:$GOROOT/bin
export GOBIN=$GOROOT/bin

# DOTFILE
export DOTFILE=$HOME/.dotfiles
export PATH=$PATH:$DOTFILE/bin

## 色の関係 ##
# 色を使用
autoload -Uz colors
colors
# lsコマンド時、自動で色がつく(ls -Gのようなもの？)
export CLICOLOR=true
# 補完候補に色を付ける
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}

## 補完関係 ##
autoload -Uz compinit
compinit
# 補完後、メニュー選択モードになり左右キーで移動が出来る
zstyle ':completion:*:default' menu select=1
# 補完で大文字にもマッチ
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
# sudo の後ろでコマンド名を補完する
zstyle ':completion:*:sudo:*' command-path /usr/local/sbin /usr/local/bin /usr/sbin /usr/bin /sbin /bin /usr/X11R6/bin

# Change color of suggestion
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=243'

##履歴関係
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
# 他のターミナルとヒストリーを共有
setopt share_history
# ヒストリーに重複を表示しない
setopt histignorealldups
# コマンドを途中まで入力後、historyから絞り込み
# 例 ls まで打ってCtrl+pでlsコマンドをさかのぼる、Ctrl+bで逆順
autoload -Uz history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey "^p" history-beginning-search-backward-end
bindkey "^b" history-beginning-search-forward-end
# 余分なスペースを削除してヒストリに保存する
setopt hist_reduce_blanks

## CD関係 ##
# cdコマンドを省略して、ディレクトリ名のみの入力で移動
setopt auto_cd
# cdの後にlsを実行
chpwd() { ls -ltr --color=auto }
# ビープ音を鳴らさないようにする
setopt no_beep
# コマンドのスペルを訂正する
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

## エイリアス ##
source ~/.dotfiles/zsh/*.zsh

### Added by Zplugin's installer
source "$HOME/.zplugin/bin/zplugin.zsh"
autoload -Uz _zplugin
# プラグインが使うコマンドをこのタイミングで autoload しておきます。
autoload -Uz add-zsh-hook
autoload -Uz cdr
autoload -Uz chpwd_recent_dirs
(( ${+_comps} )) && _comps[zplugin]=_zplugin
### End of Zplugin's installer chunk

## zplug plugins ##
zplugin light "mafredri/zsh-async"
# rename tmux windows base on git branch name
zplugin light 'sei40kr/zsh-tmux-rename'
# 作業ディレクトリに .env ファイルがあった場合に自動的にロードしてくれます。
zplugin snippet 'OMZ::plugins/dotenv/dotenv.plugin.zsh'
# エイリアスは重宝するものが多く、Gitを使うユーザーには必ずオススメしたいプラグインです。
zplugin snippet 'OMZ::plugins/git/git.plugin.zsh'
# GitHub のレポジトリを管理するためのコマンドを定義するプラグインです。
zplugin snippet 'OMZ::plugins/github/github.plugin.zsh'
# fzf command-line fuzzy finder
zplugin ice from"gh-r" as"program"; zplugin load junegunn/fzf-bin
# Speed up dir change
zplugin light "b4b4r07/enhancd"
# Highlight syntax
zplugin ice wait'1' atload'_zsh_highlight'
zplugin light 'zdharma/fast-syntax-highlighting'
# Search in history
zplugin light "zsh-users/zsh-history-substring-search"
# ZSH auto-suggest
zplugin ice wait'1' atload'_zsh_autosuggest_start'
# ZSH completion
zplugin light "zsh-users/zsh-completions"
# Default 256bit terminal
zplugin light "chrissicool/zsh-256color"
# sudo plugin (ESC to add sudo to last command)
zplugin snippet"OMZ::plugins/sudo/sudo.plugin.zsh"
# Web-search plugin (type google[firefox]  [search-phrase]) 
zplugin snippet 'OMZ::plugins/web-search/web-search.plugin.zsh'
# Spaceship theme
zplugin ice pick'spaceship.zsh' wait'!0'
zplugin light 'denysdovhan/spaceship-zsh-theme'
# sudo plugin
zplugin snippet 'OMZ::plugins/sudo/sudo.plugin.zsh'
