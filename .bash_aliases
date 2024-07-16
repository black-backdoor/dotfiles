# --- FILESYSTEM ---

# default folders
alias home='cd ~'
alias root='cd /'

# directory navigation
alias ..='cd ..'
alias ...='cd ..; cd ..'
alias ....='cd ..; cd ..; cd ..'



# --- OTHER ---

# number of week
alias week='date +%V'

# IP Addresses
alias local-ip='hostname -I'
alias public-ip='dig ANY +short @resolver2.opendns.com myip.opendns.com'
