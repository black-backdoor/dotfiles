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


echo "--- INSTALLATION ---"
if [ -e $HOME/.bash_aliases ]; then
    echo "File .bash_aliases already exists."
    $HOME/dotfiles/scripts/source-file.sh .bashrc .bash_aliases
else
    echo "File .bash_aliases does not exist."

    # check if script runs with --copy flag
    if [ "$1" == "--copy" ]; then
        echo "Copy the necessary dependencies... (bashrc files)"
        ln -s $HOME/dotfiles/.bash_aliases $HOME/.bash_aliases
        success "Successfully copied .bash_aliases"
        $HOME/dotfiles/scripts/source-file.sh .bashrc .bash_aliases
    else
        fail "File .bash_aliases does not exist & script runs without --copy flag."
    fi
fi