#!/bin/bash

# set -e  # Makes the script exit immediately if any command exits with a non-zero status.

# ------- LOG -------
wait_user () {
  echo ''
  printf "[\033[0;33m??\033[0m] $1\n"
  printf " \033[0;32m>>>\033[0m Press any key to continue"
  read -n 1 -s -r -p ''
  echo ''
}

success () {
  printf "[\033[00;32mOK\033[0m] $1\n"
}

warning() {
  printf "[\033[38;5;208mWARN\033[0m] $1\n"
  echo ''
}

fail () {
  printf "[\033[0;31mFAIL\033[0m] $1\n"
  echo ''
}

# -------------------



if [[ $EUID -ne 0 ]]; then
  fail "This script must be run as root."
  exit 1
fi



user="$SUDO_USER"
if [ -z "$user" ]; then
  fail "Could not detect non-root user."
  exit 1
fi

export HOME=/home/$user
echo -e "Installing dotfiles for \e[34m$user\e[0m in \e[36m$HOME\e[0m"
echo " USER: $user"
echo " HOME Folder: $HOME"

wait_user "Review the settings above and press any key to continue or Ctrl+C to cancel..."



echo ''
echo "---------------- DEPENDENCIES ----------------"

if [ -e $HOME/dotfiles/scripts/dependencies.sh ]; then
    echo "Found dependencies.sh"
	chmod +x $HOME/dotfiles/scripts/dependencies.sh
	
	echo "installing dependencies"
	sudo $HOME/dotfiles/scripts/dependencies.sh
	
	success "Successfully ran dependencies.sh"
else
    warning "dependencies.sh not found. Some features may not work correctly."
fi



echo ''
echo "---------------- SETUP SYMLINKS ----------------"
#if ! apt install stow -y > /dev/null; then
#    fail "Error installing 'stow' package"
#    exit 1
#fi


# ! Remove the existing .dotfiles
target_dir="$HOME/dotfiles"


# List all existing symbolic links pointing to the dotfiles directory
echo "Existing symbolic links pointing to the dotfiles directory:"
find "$HOME" -maxdepth 1 -type l -exec sh -c 'readlink -f "$0" | grep -q "^$HOME/dotfiles"' {} \; -print

wait_user "Check the symlinks above and press any key to continue or Ctrl+C to cancel..."


# remove all existing symbolic links pointing to the dotfiles directory
find "$HOME" -maxdepth 1 -type l -exec sh -c 'readlink -f "$0" | grep -q "^$HOME/dotfiles"' {} \; -delete

success "Successfully unlinked symbolic links pointing to $target_dir"

