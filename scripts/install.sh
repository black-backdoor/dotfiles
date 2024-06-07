#!/bin/bash

# set -e  # Makes the script exit immediately if any command exits with a non-zero status.

# ------- LOG -------
success () {
  printf "[\033[00;32mOK\033[0m] $1\n"
}

warning() {
  printf "[\033[38;5;208mWARN\033[0m] $1\n"
}

fail () {
  printf "[\033[0;31mFAIL\033[0m] $1\n"
  echo ''
}

user () {
  echo ''
  printf "[\033[0;33m??\033[0m] $1\n"
}

# -------------------

pause () {
  read -rp "Press enter to continue..."
}

ask() {
  printf "[\033[0;33m??\033[0m] $1\n"
  printf " \033[0;32m>>>\033[0m "
  read -p "(Y/n): " resp
  if [ -z "$resp" ]; then
    response_lc="y" # empty is Yes
  else
    response_lc=$(echo "$resp" | tr '[:upper:]' '[:lower:]') # case insensitive
  fi
  
  [ "$response_lc" = "y" ]
}

# -------------------

source_file() {
  # Modify the config file to source the file if it is not already sourced

  local config_file="$1"
  local file="$2"

  if [ ! -f "$file" ]; then
    warning "The file '$file' does not exist."
    return
  fi
  
  # Check if the file is sourced in the config_file
  if grep -q -P "^\s*(source|\.)\s+\~/$file\b" "$config_file"; then
    echo "The file '$file' is sourced in the $config_file config."
  else
    warning "The file '$file' is not sourced in the $config_file config."
    if ask "Do you want to modify $config_file to source $file?"; then
      echo "if [ -f ~/$file ]; then" >> $config_file
      echo "   source ~/$file" >> $config_file
      echo "fi" >> $config_file
    fi
  fi
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

user "CONFIRM: Verify the user and home folder above"
pause



echo ''
echo "---------------- DEPENDENCIES ----------------"

echo "Installing necessary dependencies..."

if [ -e $HOME/dotfiles/scripts/dependencies.sh ]; then
  echo "Found dependencies.sh"
  chmod +x $HOME/dotfiles/scripts/dependencies.sh
  
  echo "installing dependencies"
  sudo $HOME/dotfiles/scripts/dependencies.sh
  
  success "Successfully ran dependencies.sh"
else
  fail "dependencies.sh not found"
  fail "Cannot install the necessary dependencies for the installation."
  exit 1
fi


echo ''
echo "---------------- OPTIONS ----------------"
echo ''
echo "Select an option:"
echo " 1) Only install .bash_aliases"
echo " 2) Symlink all dotfiles & setup bash configurations"
echo ''
read -p "Enter option: " option
echo ''


if [ "$option" = "1" ]; then
  echo "Option 1: Only install .bash_aliases"
  if [ -f "$HOME/.bash_aliases" ]; then
    warning "The file '.bash_aliases' already exists."

    if [ -L "$HOME/.bash_aliases" ]; then
      warning "The file '.bash_aliases' is a symbolic link."
      warning "The file '.bash_aliases' links to: $(readlink -f $HOME/.bash_aliases)"
    fi
    
    # Ask to overwrite the existing .bash_aliases file
    if ask "Do you want to overwrite the existing .bash_aliases file?"; then
      # If the file is a symbolic link, unlink it | if not, remove it
      if [ -L "$HOME/.bash_aliases" ]; then
        unlink "$HOME/.bash_aliases"
        echo "Successfully unlinked .bash_aliases"
      else
        rm "$HOME/.bash_aliases"
        echo "Successfully removed .bash_aliases"
      fi

      # Create a new symbolic link to the .bash_aliases file
      if ask "Do you want to copy the .bash_aliases file? If not, a symbolic link will be created."; then
        cp "$HOME/dotfiles/.bash_aliases" "$HOME/.bash_aliases"
        success "Successfully copied .bash_aliases"
      else
        ln -s "$HOME/dotfiles/.bash_aliases" "$HOME/.bash_aliases"
        success "Successfully symlinked .bash_aliases"
      fi

      # Source the .bash_aliases file
      cd "$HOME"
      source_file .bashrc .bash_aliases

      exit 0
    else
      fail "Aborted."
      exit 1
    fi
  else
    cp "$HOME/dotfiles/.bash_aliases" "$HOME/.bash_aliases"
    success "Successfully copied .bash_aliases"
  fi
elif [ "$option" = "2" ]; then
  echo "Option 2: Symlink all dotfiles & setup bash configurations"
else
  fail "Invalid option"
  exit 1
fi



echo ''
echo "---------------- INSTALL DEPENDENCIES FOR BASH ----------------"
echo "Installing necessary dependencies..."

if [ -e $HOME/dotfiles/scripts/basic-dependencies.sh ]; then
  echo "Found basic-dependencies.sh"
  chmod +x $HOME/dotfiles/scripts/basic-dependencies.sh
  
  echo "installing basic-dependencies.sh"
  sudo $HOME/dotfiles/scripts/basic-dependencies.sh
  
  success "Successfully ran basic-dependencies.sh"
else
  fail "basic-dependencies.sh not found"
  fail "Cannot install the necessary dependencies for the installation."
  exit 1
fi



echo ''
echo "---------------- SETUP SYMLINKS ----------------"
#if ! apt install stow -y > /dev/null; then
#  fail "Error installing 'stow' package"
#  exit 1
#fi


# ! Remove the existing .dotfiles
target_dir="$HOME/dotfiles"


# List all existing symbolic links pointing to the dotfiles directory
echo "Existing symbolic links pointing to the dotfiles directory:"
find "$HOME" -maxdepth 1 -type l -exec sh -c 'readlink -f "$0" | grep -q "^$HOME/dotfiles"' {} \; -print

user "CONFIRM: Remove all existing symbolic links pointing to the dotfiles directory | list above"
pause


# remove all existing symbolic links pointing to the dotfiles directory
find "$HOME" -maxdepth 1 -type l -exec sh -c 'readlink -f "$0" | grep -q "^$HOME/dotfiles"' {} \; -delete

success "Successfully unlinked symbolic links pointing to $target_dir"

# -------------------

cd "$HOME/dotfiles" || { fail "Failed to cd $HOME/dotfiles"; exit 1; }

echo "Use 'stow' to create symlinks in the parent directory (user's home directory)"
if ! stow .; then
  fail "Error running stow."
  exit 1
fi

success "Successfully used 'stow' to create symlinks."



echo ''
echo "---------------- CUSTOM .bashrc ----------------"

cd "$HOME"

source_file .bashrc .bash_aliases
source_file .bashrc .bash_tools