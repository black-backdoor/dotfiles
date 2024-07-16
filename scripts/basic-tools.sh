#!/bin/bash

# ------- LOG -------
success () {
  printf "[\033[00;32mOK\033[0m] $1\n"
}

warning () {
  printf "[\033[38;5;208mWARN\033[0m] $1\n"
}

fail () {
  printf "[\033[0;31mFAIL\033[0m] $1\n"
  echo ''
}


echo "--- DEPENDENCIES ---"
apt install xsel -y  # used for copying to & from clipboard | clipcopy & clippaste commands


echo "--- INSTALLATION ---"
if [ -e $HOME/.bash_tools ]; then
    echo "File .bash_tools already exists."
    $HOME/dotfiles/scripts/source-file.sh .bashrc .bash_tools
else
    echo "File .bash_tools does not exist."

    # check if script runs with --copy flag
    if [ "$1" == "--copy" ]; then
        echo "Copy the necessary dependencies... (bashrc files)"
        ln -s $HOME/dotfiles/.bash_tools $HOME/.bash_tools
        success "Successfully copied .bash_tools"
        $HOME/dotfiles/scripts/source-file.sh .bashrc .bash_tools
    else
        fail "File .bash_tools does not exist & script runs without --copy flag."
    fi
fi


