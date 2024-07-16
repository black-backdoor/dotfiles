#!/bin/bash

echo "-------- DEPENDENCIES "--------
apt install stow -y  # used for managing symlinks

cd $HOME/dotfiles
stow .
