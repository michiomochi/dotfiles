#!/bin/bash
PWD=$(pwd)

echo "Gen Symbolic Link gitconfig => ~/.gitconfig"
ln -sf ${PWD}/gitconfig ~/.gitconfig

echo "Gen Symbolic Link vim => ~/.vim"
ln -sf ${PWD}/vim ~/.vim

echo "Gen Symbolic Link vimrc => ~/.vimrc"
ln -sf ${PWD}/vimrc ~/.vimrc

echo "Gen Symbolic Link tmux.conf => ~/.tmux.conf"
ln -sf ${PWD}/tmux.conf ~/.tmux.conf

echo "Gen Symbolic Link local => ~/local"
ln -sf ${PWD}/local ~/local

echo "Gen Symbolic Link gitignore => ~/.gitignore"
ln -sf ${PWD}/gitignore ~/.gitignore
