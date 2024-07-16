#!/bin/bash

# dependencies.sh
# This script installs the necessary dependencies for the install.sh script to work correctly.
# It ensures that all required packages and tools are available on the system before running the installation process.

# Update the package list
apt update

# ---------- PACKAGES ----------
apt install git -y
apt install wget -y

# ---------- TOOLS ----------
#cd $HOME/dotfiles/scripts
#chmod +x checkbox.sh
#wget https://github.com/pedro-hs/checkbox.sh/raw/master/checkbox.sh
apt install dialog -y