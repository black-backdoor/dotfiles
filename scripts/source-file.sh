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


if [ $# -ne 2 ]; then
    echo "Usage: source-file.sh modify_file file"
    echo "modify_file: the file to modify"
    echo "file: the file to source"
    exit 1
fi

modify_file="$1"
file="$2"

if [ ! -f "$file" ]; then
    fail "The file '$file' does not exist."
    exit 1
fi

if [ ! -f "$modify_file" ]; then
    fail "The file '$modify_file' does not exist."
    exit 1
fi


# Check if the file is sourced in the modify_file
if grep -q -P "^\s*(source|\.)\s+\~/$file\b" "$modify_file"; then
    warning "The file '$file' is sourced in the $modify_file config."
else
    echo "The file '$file' is not sourced in the $modify_file config."
    echo "" >> $modify_file
    echo "if [ -f ~/$file ]; then" >> $modify_file
    echo "   source ~/$file" >> $modify_file
    echo "fi" >> $modify_file
    success "The file '$file' is now sourced in the $modify_file config."
fi