#!/bin/sh

dotfiles=$HOME/.dotfiles


echo "Bootstrap $dotfiles"

# ZSH Config

ln -s $dotfiles/zsh/zshrc $HOME/.zshrc
ln -s $dotfiles/zsh/oh-my-zsh $HOME/.oh-my-zsh


# TMUX Config

ln -s $dotfiles/tmux/tmux.conf $HOME/.tmux.conf


# VIM Config

ln -s $dotfiles/vim/vimrc $HOME/.vimrc

