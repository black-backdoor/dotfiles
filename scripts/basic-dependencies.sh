#!/bin/bash

# basic-dependencies.sh
# This script installs the basic dependencies required for additional tools that enhance the user's experience with the bash console.



# Update the package list
apt update



# ---------- USER ----------

apt install xsel -y  # used for copying to & from clipboard | clipcopy & clippaste commands