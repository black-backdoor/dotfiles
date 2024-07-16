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

# --- alternative ways to get public IP ---
# Uncomment one of the following aliases to use an alternative method to get the public IP address:
# - The first one returns the IP address in the format: "192.168.1.1"
# - The second one parses it to get only the IP: 192.168.1.1
#
# alias public-ip='dig TXT +short o-o.myaddr.l.google.com @ns1.google.com'
# alias public-ip="dig TXT +short o-o.myaddr.l.google.com @ns1.google.com | awk -F'\"' '{ print \$2}'"
#
# alias public-ip='dig +short txt ch whoami.cloudflare @1.0.0.1'
# alias public-ip="dig +short txt ch whoami.cloudflare @1.0.0.1 | awk -F'\"' '{ print \$2}'"