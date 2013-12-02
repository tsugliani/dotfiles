#!/bin/sh

dotfiles=$HOME/.dotfiles

echo "Bootstrap $dotfiles"

# BASH Config
ln -s $dotfiles/bash/bash_prompt $HOME/.bash_prompt

# ZSH Config
ln -s $dotfiles/zsh/zshrc $HOME/.zshrc
ln -s $dotfiles/zsh/oh-my-zsh $HOME/.oh-my-zsh

# TMUX Config
ln -s $dotfiles/tmux/tmux.conf $HOME/.tmux.conf

# VIM Config
ln -s $dotfiles/vim/vimrc $HOME/.vimrc

# GIT config
ln -s $dotfiles/git/gitconfig $HOME/.gitconfig
ln -s $dotfiles/git/gitignore_global $HOME/.gitignore_global
