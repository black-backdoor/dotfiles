#!/bin/bash



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

