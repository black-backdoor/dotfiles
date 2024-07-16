#!/bin/bash

# set -e  # Makes the script exit immediately if any command exits with a non-zero status.

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

user () {
  echo ''
  printf "[\033[0;33m??\033[0m] $1\n"
}

# -------------------

pause () {
  read -rp "Press enter to continue..."
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
echo "---------------- VERIFY SCRIPTS ----------------"

SCRIPTS=("source-file.sh" "basic-bash-aliases.sh" "basic-tools.sh" "stow.sh")


for script in "${SCRIPTS[@]}"; do
  if [ -e "$HOME/dotfiles/scripts/$script" ]; then
    success "Found $script"
    chmod +x "$HOME/dotfiles/scripts/$script"
  else
    fail "$script not found"
    fail "Cannot run the installation scripts."
    exit 1
  fi
done


echo ''
echo "---------------- SETUP SYMLINKS ----------------"

# remove all existing symbolic links pointing to the dotfiles directory
target_dir="$HOME/dotfiles"


# List all existing symbolic links pointing to the dotfiles directory
echo "Existing symbolic links pointing to the dotfiles directory:"
find "$HOME" -maxdepth 1 -type l -exec sh -c 'readlink -f "$0" | grep -q "^$HOME/dotfiles"' {} \; -print

user "CONFIRM: Remove all existing symbolic links pointing to the dotfiles directory | list above"
pause


# remove all existing symbolic links pointing to the dotfiles directory
find "$HOME" -maxdepth 1 -type l -exec sh -c 'readlink -f "$0" | grep -q "^$HOME/dotfiles"' {} \; -delete

success "Successfully unlinked symbolic links pointing to $target_dir"



echo ''
echo "---------------- OPTIONS ----------------"

# Define the dialog exit status codes
: ${DIALOG_OK=0}
: ${DIALOG_CANCEL=1}
: ${DIALOG_HELP=2}
: ${DIALOG_EXTRA=3}
: ${DIALOG_ITEM_HELP=4}
: ${DIALOG_ESC=255}

# Duplicate (make a backup copy of) file descriptor 1 
# on descriptor 3
exec 3>&1

# Generate the checklist dialog box while running dialog in a subshell
result=$(dialog \
  --title "CHECKLIST BOX" \
  --clear \
  --checklist "Select scripts to run:" 15 51 5 \
  1 "Stow Dotfiles" off \
  2 "Helpfull Bash Aliases" on \
  3 "Basic Bash Tools" on \
  2>&1 1>&3)

# Get dialog's exit status
return_value=$?

# Close file descriptor 3
exec 3>&-

# Act on the exit status
case $return_value in
  $DIALOG_OK)
    echo "Selected options: $result";;
  $DIALOG_CANCEL)
    fail "Cancel pressed.";;
  $DIALOG_HELP)
    fail "Help pressed.";;
  $DIALOG_EXTRA)
    fail "Extra button pressed.";;
  $DIALOG_ITEM_HELP)
    fail "Item-help button pressed.";;
  $DIALOG_ESC)
    if test -n "$result" ; then
      echo "$result"
    else
      echo "ESC pressed."
    fi
    ;;
esac

# Copy the selected options to the clipboard if OK was pressed
if [ $return_value -eq $DIALOG_OK ]; then
    echo "$result"
fi

for script_index in $result; do
  case $script_index in
    1)
      echo "Stow Dotfiles"
      $HOME/dotfiles/scripts/stow.sh
      ;;
    2)
      echo "Helpfull Bash Aliases"
      
      if [[ $result != *1* ]]; then
        $HOME/dotfiles/scripts/basic-bash-aliases.sh --copy
      else
        $HOME/dotfiles/scripts/basic-bash-aliases.sh
      fi
      ;;
    3)
      echo "Basic Bash Tools"
      if [[ $result != *1* ]]; then
        $HOME/dotfiles/scripts/basic-tools.sh --copy
      else
        $HOME/dotfiles/scripts/basic-tools.sh
      fi
      ;;
    *)
      fail "Invalid option selected / Option not found."
      exit 1
      ;;
  esac
done

