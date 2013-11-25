#!/bin/bash

DOT_FILES=(.zshrc .vimrc .bashrc .vim .tmux.conf .zsh)

for file in ${DOT_FILES[@]}
do
        # 該当の設定ファイルがすでに存在する場合は後ろに.bakをつけリネームする
        if [ -e $HOME/${file} ]; then
                mv $HOME/${file} $HOME/${file}.bak
        fi
        # シンボリックリンクの作成
        ln -s $HOME/dotfiles/${file} $HOME/${file}
done

# 文字コード、改行コードの変換
find . -type f | grep -v .git | xargs -n 10 nkf -w -Lu --overwrite

# .vim submodule init & update
cd $HOME/dotfiles
git submodule init
git submodule update 

# install oh-my-zsh
if [ ! -d $HOME/.oh-my-zsh ]; then
        git clone https://github.com/robbyrussell/oh-my-zsh.git $HOME/.oh-my-zsh
fi
