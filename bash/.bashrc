# .bashrc

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# --- Source Shared Configurations ---
# Source aliases and functions shared with Zsh
[[ -f "$HOME/dotfiles/shell/aliases.sh" ]] && source "$HOME/dotfiles/shell/aliases.sh"
[[ -f "$HOME/dotfiles/shell/functions.sh" ]] && source "$HOME/dotfiles/shell/functions.sh"

# --- Bash Options ---
# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# --- History ---
HISTCONTROL=ignoreboth:erasedups
HISTSIZE=10000
HISTFILESIZE=20000

# --- Prompt (PS1) ---
# Basic colored prompt: user@host:dir$ 
if [[ ${EUID} == 0 ]] ; then
    PS1='\[\033[01;31m\]\u@\h\[\033[01;34m\] \w \$\[\033[00m\] '
else
    PS1='\[\033[01;32m\]\u@\h\[\033[01;34m\] \w \$\[\033[00m\] '
fi
