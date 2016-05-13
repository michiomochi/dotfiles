#!/bin/bash
PWD=$(pwd)

echo "Gen Symbolic Link gitconfig => ~/.gitconfig"
ln -sf ${PWD}/gitconfig ~/.gitconfig

echo "Gen Symbolic Link vim => ~/.vim"
ln -sf ${PWD}/vim ~/.vim

echo "Gen Symbolic Link vimrc => ~/.vimrc"
ln -sf ${PWD}/vimrc ~/.vimrc

#echo "Gen Symbolic Link gvimrc => ~/.vimrc"
#ln -sf ${PWD}/gvimrc ~/.gvimrc

#echo "Gen Symbolic Link vimperatorrc => ~/.vimperatorrc"
#ln -sf ${PWD}/vimperatorrc ~/.vimperatorrc

#echo "Gen Symbolic Link vimperator => ~/.vimperator"
#ln -sf ${PWD}/vimperator ~/.vimperator

echo "Gen Symbolic Link tmux.conf => ~/.tmux.conf"
ln -sf ${PWD}/tmux.conf ~/.tmux.conf

echo "Gen Symbolic Link zshrc => ~/.zshrc"
ln -sf ${PWD}/zshrc ~/.zshrc

#echo "Gen Symbolic Link zshrc.github => ~/.zshrc.github"
#ln -sf ${PWD}/zshrc.github ~/.zshrc.github

echo "Gen Symbolic Link zsh => ~/.zsh"
ln -sf ${PWD}/zsh ~/.zsh

#echo "Gen Symbolic Link zshenv => ~/.zshenv"
#ln -sf ${PWD}/zshenv ~/.zshenv

#echo "Gen Symbolic Link zlogin => ~/.zlogin"
#ln -sf ${PWD}/zlogin ~/.zlogin

echo "Gen Symbolic Link oh-my-zsh => ~/.oh-my-zsh"
ln -sf ${PWD}/oh-my-zsh ~/.oh-my-zsh

#echo "Gen Symbolic Link zaw => ~/.zaw"
#ln -sf ${PWD}/zaw ~/.zaw

#echo "Gen Symbolic Link irbrc => ~/.irbrc"
#ln -sf ${PWD}/irbrc ~/.irbrc

echo "Gen Symbolic Link gitconfig => ~/.gitconfig"
ln -sf ${PWD}/gitconfig ~/.gitconfig

#echo "Gen Symbolic Link tigrc => ~/.tigrc"
#ln -sf ${PWD}/tigrc ~/.tigrc

#echo "Gen Symbolic Link peco_config.json => ~/.config/peco/config.json"
#mkdir -p ~/.config/peco

#ln -sf ${PWD}/peco_config.json ~/.config/peco/config.json

echo "Gen Symbolic Link local => ~/local"
ln -sf ${PWD}/local ~/local

echo "Gen Symbolic Link tmuxinator => ~/.tmuxinator"
ln -sf ${PWD}/tmuxinator ~/.tmuxinator

echo "Gen Symbolic Link gitignore => ~/.gitignore"
ln -sf ${PWD}/gitignore ~/.gitignore
