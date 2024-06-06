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
  echo "This script must be run as root."
  exit 1
fi

