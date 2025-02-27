#!/bin/zsh

# --- XDG Base Directory Specification Compliance ---
export XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"

# --- Zsh Configuration Setup ---
export ZDOTDIR="${XDG_CONFIG_HOME}/zsh"

# --- Directory Creation with Validation ---
create_xdg() {
    local dirs=(
        "$ZDOTDIR"
        "${XDG_CACHE_HOME}/zsh"
        "${XDG_CONFIG_HOME}/vim"
        "${XDG_CONFIG_HOME}/nvm"
        "${XDG_CONFIG_HOME}/npm"
        "${XDG_CONFIG_HOME}/python"
    )
    for dir in "${dirs[@]}"; do
        if [[ ! -d "$dir" ]]; then
            mkdir -p "$dir" || { echo "Failed to create directory '$dir'." >&2; return 1; }
        fi
    done
}
create_xdg

# --- PATH Configuration ---
user_paths=(
    "${HOME}/bin"
    "${HOME}/Developer/Playgrounds"
    "${HOME}/Developer/Projects/scripts"
)

for custom_path in "${user_paths[@]}"; do
    if [[ -d "$custom_path" ]]; then
        PATH="${custom_path}:$PATH"
    fi
done
typeset -U PATH

# --- Dotfiles Management ---
[[ -d "${HOME}/dotfiles" ]] && export DOT="${HOME}/dotfiles"

# --- Application Defaults ---
export PAGER="less"
export EDITOR="vim"
export VISUAL="code"  # Fallback to VS Code for GUI editing on macOS

# --- Less Configuration ---
export LESS="-R -i -g -c -W -M -J"
export LESSHISTFILE="-"  # Disable less history file

# --- Locale Settings ---
export LC_ALL=C
export LC_COLLATE=C
export LANG="en_US.UTF-8"

# --- Python Configuration ---
export PYTHONSTARTUP="${XDG_CONFIG_HOME}/python/pythonrc"
export PYTHONHISTORY="${XDG_CONFIG_HOME}/python/history"

# --- Vim Configuration ---
export MYVIMRC="${XDG_CONFIG_HOME}/vim/vimrc"
export VIMINIT="source ${MYVIMRC}"
