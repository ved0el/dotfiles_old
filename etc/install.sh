#!/bin/bash

DOTPATH=~/.dotfiles

# # git が使えるなら git
# if has "git"; then
#     git clone --recursive "$GITHUB_URL" "$DOTPATH"
    
#     # 使えない場合は curl か wget を使用する
# elif has "curl" || has "wget"; then
#     # tarball="https://github.com/b4b4r07/dotfiles/archive/master.tar.gz" 
    
#     # どっちかでダウンロードして，tar に流す
#     if has "curl"; then
#         curl -L "$tarball"
        
#     elif has "wget"; then
#         wget -O - "$tarball"
        
#     fi | tar zxv
    
#     # 解凍したら，DOTPATH に置く
#     mv -f dotfiles-master "$DOTPATH"
    
# else
#     die "curl or wget required"
# fi

cd ~/.dotfiles
if [ $? -ne 0 ]; then
    die "not found: $DOTPATH"
fi

deploy() {
    make deploy
}

initalize() {
    #...
    echo "init"
}

if [ "$1" = "-deploy" -o "$1" = "-d" ]; then
    deploy
elif [ "$1" = "-init" -o "$1" = "-i" ]; then
    initalize
fi
