# Set the directory we want to store zinit and plugins
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

# Download Zinit, if it's not there yet
if [ ! -d "$ZINIT_HOME" ]; then
   mkdir -p "$(dirname $ZINIT_HOME)"
   git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

# Source/Load zinit
source "${ZINIT_HOME}/zinit.zsh"

# Add in zsh plugins
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light Aloxaf/fzf-tab

# Load completions
autoload -Uz compinit && compinit

# ---- oh-my-posh ----
eval "$(oh-my-posh init zsh --config $HOME/.config/oh-my-posh/bare.toml)"

# ---- Keybindings ----
#bindkey -e
bindkey '^f' autosuggest-accept
#bindkey '^p' history-search-backward
#bindkey '^n' history-search-forward

# ---- History ----
# number of commands to remember
HISTSIZE=5000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
# append to the history file, don't overwrite it
setopt appendhistory
# share history between sessions
setopt sharehistory
# ignore commands that start with a space -> privacy
setopt hist_ignore_space
setopt hist_ignore_all_dups
# Don't save duplicate commands
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

# Completion styling
# ignore case when completing
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no


# ---- Eza (better ls) ----
alias ls='eza --color=always --long --git --no-filesize --icons=always --no-time --no-user --no-permissions'

# ---- TheFuck -----
# thefuck alias
eval $(thefuck --alias)
eval $(thefuck --alias fk)

# ---- Ffz ----
# Shell integrations
eval "$(fzf --zsh)"


show_file_or_dir_preview="if [ -d {} ]; then eza --tree --color=always {} | head -200; else bat -n --color=always --line-range :500 {}; fi"

export FZF_CTRL_T_OPTS="--preview '$show_file_or_dir_preview'"
export FZF_ALT_C_OPTS="--preview 'eza --tree --color=always {} | head -200'"

# Advanced customization of fzf options via _fzf_comprun function
# - The first argument to the function is the name of the command.
# - You should make sure to pass the rest of the arguments to fzf.
_fzf_comprun() {
  local command=$1
  shift

  case "$command" in
    cd)           fzf --preview 'eza --tree --color=always {} | head -200' "$@" ;;
    export|unset) fzf --preview "eval 'echo \${}'"         "$@" ;;
    ssh)          fzf --preview 'dig {}'                   "$@" ;;
    *)            fzf --preview "$show_file_or_dir_preview" "$@" ;;
  esac
}
