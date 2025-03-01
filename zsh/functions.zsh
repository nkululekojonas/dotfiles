#!/bin/bash

# functions.zsh: A collection of useful shell functions for enhanced command-line experience
# Author: Nkululeko Jonas
# Date: 23-10-2023

# Create a new directory and enter it
mcd() {
    if [ $# -eq 0 ]; then
        echo "Error: No directory name provided"
        return 1
    fi
    if mkdir -p "$@"; then
        cd "$_" || return 1
    else
        echo "Error: Failed to create directory"
        return 1
    fi
}

# Determine size of a file or total size of a directory
fs() {
    if command -v gdu >/dev/null 2>&1; then
        local du_cmd="gdu"
    else
        local du_cmd="du"
    fi

    if $du_cmd -b /dev/null > /dev/null 2>&1; then
        local arg=-sbh;
    else
        local arg=-sh;
    fi
    if [[ -n "$*" ]]; then
        $du_cmd $arg -- "$@";
    else
        $du_cmd $arg .[^.]* ./*;
    fi;
}

# Generate a random password
genpass() {
    local length=${1:-16}
    LC_ALL=C tr -dc 'A-Za-z0-9!@#$%^&*()_+' </dev/urandom | head -c "$length"
}

# Show most used commands
topcmds() {
  local num=${1:-10} # Default to showing top 10 commands
  history | awk '{CMD[$2]++; count++;} END {for (a in CMD) print CMD[a], CMD[a]/count*100 "%", a;}' | sort -nr | head -n "$num"
}

# Perform system update with enhanced error handling
update() {
    # Check sudo privileges
    sudo -v || { echo "Error: Failed to get sudo privileges. Aborting update."; return 1; }

    # Parse arguments
    local update_all=true
    local update_mas=false
    local update_omz=false
    local update_brew=false
    local update_macos=false

    while [[ $# -gt 0 ]]; do
        case $1 in
            --mas) update_mas=true; update_all=false ;;
            --omz) update_omz=true; update_all=false ;;
            --brew) update_brew=true; update_all=false ;;
            --macos) update_macos=true; update_all=false ;;
            *) echo "Unknown option: $1"; return 1 ;;
        esac
        shift
    done

    # macOS Software update
    if $update_all || $update_macos; then
        echo "Updating macOS software..."
        sudo softwareupdate -i -a || { echo "Error: macOS software update failed."; return 1; }
    fi

    # Homebrew update
    if ($update_all || $update_brew) && command -v brew &> /dev/null; then
        echo "Updating Homebrew..."
        brew cu -facy || { echo "Error: Brew upgrade outdated apps failed"; return 1; } 
        brew upgrade || { echo "Error: Brew upgrade failed."; return 1; }
        brew cleanup || { echo "Error: Brew cleanup failed."; return 1; }
        brew autoremove || { echo "Error: Brew autoremove failed."; return 1; }
    elif $update_brew; then
        echo "Warning: Homebrew is not installed."
    fi

    # Mac App Store updates
    if ($update_all || $update_mas) && command -v mas &> /dev/null; then
        echo "Updating Mac App Store apps..."
        mas outdated
        mas upgrade || { echo "Error: Mac App Store upgrade failed."; return 1; }
    elif $update_mas; then
        echo "Warning: mas-cli (Mac App Store CLI) is not installed."
    fi

    # Oh My Zsh update
    if ($update_all || $update_omz) && command -v omz &> /dev/null; then
        echo "Updating Oh My Zsh..."
        omz update || { echo "Error: Oh My Zsh update failed."; return 1; }
    elif $update_omz; then
        echo "Warning: Oh My Zsh is not installed."
    fi

    echo "All updates completed successfully!"
}
