#!/bin/bash

# dependencies.sh
# This script installs the necessary dependencies for the install.sh script to work correctly.
# It ensures that all required packages and tools are available on the system before running the installation process.



# Update the package list
apt update



# ---------- SYSTEM / SCRIPT ----------
apt install git -y
apt install stow -y
