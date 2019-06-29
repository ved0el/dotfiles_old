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
#    chpwd() { ls -ltr --color=auto }
# ビープ音を鳴らさないようにする
setopt no_beep
# コマンドのスペルを訂正する
setopt correct

# zplug init
source ~/.zplug/init.zsh
# zplugを.zshrcさえ持ってくればインストールできるようにする
function zplug-install (){
	curl -sL --proto-redir -all,https https://raw.githubusercontent.com/zplug/installer/master/installer.zsh | zsh
}

## zplug plugins ##
# manage 'zplug' ifself
zplug 'zplug/zplug', hook-build:'zplug --self-manage'
zplug "mafredri/zsh-async"
# fzf command-line fuzzy finder
zplug "junegunn/fzf-bin", as:command, from:gh-r, rename-to:fzf
# fzf tmux plugin
zplug "junegunn/fzf", as:command, use:bin/fzf-tmux
# peco
zplug "peco/peco", as:command, from:gh-r, use:"*amd64*"
# peco-tmux
zplug "b4b4r07/dotfiles", as:command, use:bin/peco-tmux
# Speed up dir change
zplug "b4b4r07/enhancd", use:init.sh
# Highlight syntax
zplug "zdharma/fast-syntax-highlighting"
# Search in history
zplug "zsh-users/zsh-history-substring-search"
# Emoji in terminal
zplug "b4b4r07/emoji-cli"
# Solarized for dir color
zplug "liangguohuan/zsh-dircolors-solarized"
# ZSH completion
zplug "zsh-users/zsh-autosuggestions"
zplug "zsh-users/zsh-completions"
zplug "chrissicool/zsh-256color"
zplug "plugins/sudo",   from:oh-my-zsh
zplug "plugins/web-search", from:oh-my-zsh

# Change color of suggestion
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=243'
# Directory colors
zplug "seebi/dircolors-solarized", ignore:"*", as:plugin
# Tmux solarzed
zplug  'seebi/tmux-colors-solarized', as:plugin
# Install plugins if there are plugins that have not been installed
if ! zplug check --verbose; then
    printf "Install? [y/N]: "
    if read -q; then
        echo; zplug install
    fi
fi
# Then, source plugins and add commands to $PATH
zplug load

## percol config
function exists { which $1 &> /dev/null }

if exists percol; then
    function percol_select_history() {
        local tac
        exists gtac && tac="gtac" || { exists tac && tac="tac" || { tac="tail -r" } }
        BUFFER=$(fc -l -n 1 | eval $tac | percol --query "$LBUFFER")
        CURSOR=$#BUFFER         # move cursor
        zle -R -c               # refresh
    }
    
    zle -N percol_select_history
    bindkey '^R' percol_select_history
fi

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
