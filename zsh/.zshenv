#!/bin/zsh

# --- Error Logging ---
error() {
    echo "Error: $1" >&2
}

# --- XDG Base Directory Specification Compliance ---
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
export XDG_STATE_HOME="${XDG_STATE_HOME:-$HOME/.local/state}"
export XDG_RUNTIME_DIR="${XDG_RUNTIME_DIR:-$HOME/.local/run}"
export XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"  

# Ensure secure runtime directory (critical for macOS)
if [[ ! -d "$XDG_RUNTIME_DIR" ]]; then
    mkdir -p "$XDG_RUNTIME_DIR" && chmod 0700 "$XDG_RUNTIME_DIR"
fi

# --- Zsh Configuration Setup ---
export ZDOTDIR="$XDG_CONFIG_HOME/zsh"

# --- Directory Creation with Validation ---
create_xdg() {
    local dirs=(
        "$ZDOTDIR"
        "$XDG_CACHE_HOME/zsh"
        "$XDG_CONFIG_HOME/vim"
        "$XDG_CONFIG_HOME/python"
        "$XDG_CONFIG_HOME/nvm"
        "$XDG_CONFIG_HOME/npm"
    )
    for dir in "${dirs[@]}"; do
        if [[ ! -d "$dir" ]]; then
            mkdir -p "$dir" || { error "Failed to create directory '$dir'."; return 1; }
        fi
    done
}
create_xdg

# --- PATH Configuration ---
user_paths=(
    "$HOME/bin"
    "$HOME/.local/bin"  # Common macOS Homebrew install location
    "$HOME/Developer/Playgrounds"
)
for custom_path in "${user_paths[@]}"; do
    if [[ -d "$custom_path" && ":$PATH:" != *":$custom_path:"* ]]; then
        PATH="$custom_path:$PATH"
    fi
done

# --- Dotfiles Management ---
[[ -d "$HOME/dotfiles" ]] && export DOT="$HOME/dotfiles"

# --- Application Defaults ---
export EDITOR="vim"
export VISUAL="code"  # Fallback to VS Code for GUI editing on macOS
export PAGER="less"

# --- Less Configuration ---
export LESS="-R -i -g -c -W -M -J"
export LESSHISTFILE="-"  # Disable less history file

# --- Locale Settings ---
export LC_ALL=C          # Default C locale (affects collation, etc.)
export LC_COLLATE=C      # Explicitly set collation to C
export LANG=en_US.UTF-8  # Use UTF-8 for language/encoding

# --- Python Configuration ---
export PYTHONSTARTUP="$XDG_CONFIG_HOME/python/pythonrc"
export PYTHONHISTORY="$XDG_CONFIG_HOME/python/history"

# --- Vim Configuration ---
export VIMINIT='let $MYVIMRC="$XDG_CONFIG_HOME/vim/vimrc" | source $MYVIMRC'
