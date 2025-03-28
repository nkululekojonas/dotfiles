#!/bin/zsh
# --- XDG Base Directory Specification Compliance ---
export XDG_CACHE_HOME="${XDG_CACHE_HOME:-"${HOME}/.cache"}"
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-"${HOME}/.config"}"
export XDG_DATA_HOME="${XDG_DATA_HOME:-"${HOME}/.local/share"}"
export XDG_STATE_HOME="${XDG_STATE_HOME:-"${HOME}/.local/state"}"
export XDG_RUNTIME_DIR="${XDG_RUNTIME_DIR:-"${HOME}/.local/run"}"

# Ensure these directories exist
mkdir -p "${XDG_CONFIG_HOME}" "${XDG_CACHE_HOME}" "${XDG_DATA_HOME}" "${XDG_STATE_HOME}"

# Ensure XDG_RUNTIME_DIR has the correct permissions
mkdir -p "${XDG_RUNTIME_DIR}" && chmod 0700 "${XDG_RUNTIME_DIR}" 

# --- Zsh Configuration Setup ---
export ZDOTDIR="${XDG_CONFIG_HOME}/zsh"
export HELPDIR="/usr/share/zsh/$(zsh --version | cut -d' ' -f2)/help"

# Ensure Zsh directory exists
mkdir -p "${ZDOTDIR}"

# --- PATH Configuration ---
# Add directories to PATH safely
PATH="/usr/local/bin:${PATH}:${HOME}/bin"

# Add Homebrew to PATH if it exists
if [[ -d "/opt/homebrew/bin" ]]; then
    # Apple Silicon
    PATH="/opt/homebrew/bin:${PATH}"
    PATH="/opt/homebrew/sbin:${PATH}"
elif [[ -d "/usr/local/Homebrew" ]]; then
    # Intel Mac
    PATH="/usr/local/bin:${PATH}"
    PATH="/usr/local/sbin:${PATH}"
fi

export PATH
# Remove duplicate entries in PATH
typeset -U PATH path

# --- Application Defaults ---
export PAGER="less"
export EDITOR="vim"
export VISUAL="vim"  

# --- Less Configuration ---
export LESS="-R -i -g -c -W -M -J"
export LESSHISTFILE="${XDG_CACHE_HOME}/less/history"
mkdir -p "$(dirname "${LESSHISTFILE}")"

# --- Locale Settings ---
# Uncomment if needed:
# export LANG=C
# export LC_ALL=C
export LC_COLLATE=C

# export LANG="en_US.UTF-8"
# export LC_ALL="en_US.UTF-8"
# export LC_COLLATE="en_US.UTF-8"

# --- Python Configuration ---
export PYTHONSTARTUP="${XDG_CONFIG_HOME}/python/pythonrc"
export PYTHONHISTORY="${XDG_CONFIG_HOME}/python/history"
# Ensure python directory exists
mkdir -p "${XDG_CONFIG_HOME}/python"

# --- Vim Configuration ---
export MYVIMRC="${XDG_CONFIG_HOME}/vim/vimrc"
export VIMINIT="source ${MYVIMRC}"
# Ensure Vim directory exists
mkdir -p "${XDG_CONFIG_HOME}/vim"

# --- macOS Specific Settings ---
# Prevent macOS from creating .DS_Store files on network volumes
export COPY_EXTENDED_ATTRIBUTES_DISABLE=true
export COPYFILE_DISABLE=true

# --- Dotfiles Management ---
[[ -d "${HOME}/dotfiles" ]] && export DOT="${HOME}/dotfiles"
