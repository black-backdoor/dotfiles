#!/bin/bash

# basic-dependencies.sh
# This script installs the basic dependencies required for additional tools that enhance the user's experience with the bash console.



# Update the package list
apt update



# install nerd font | https://www.nerdfonts.com/font-downloads > JetBrainsMono Nerd Font > download > unzip > copy to /usr/share/fonts/
apt install unzip


apt install zsh -y
apt install git -y


# ---------- ALACRITTY ----------
apt-get install build-essential
add-apt-repository ppa:aslatter/ppa -y
apt update
apt install alacritty -y

# INSTALL BREW

# ---------- oh-my-posh ----------
brew install jandedobbeleer/oh-my-posh/oh-my-posh


# ---------- eza (better ls) ----------
brew install eza

# ---------- fzf ----------
apt install fzf

# ---------- bat ----------
apt install bat

# ---------- thefuck ----------
brew install thefuck


# set zsh as default shell
chsh -s $(which zsh)