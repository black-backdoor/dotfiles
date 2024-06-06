#!/bin/bash

#
# This script installs the dependencies required for the install.sh script and the dotfiles to work properly. 
#

# Update the package list
apt update


# ---------- SYSTEM / SCRIPT ----------
apt install git -y
apt install stow -y


# ---------- USER ----------
# add your own
