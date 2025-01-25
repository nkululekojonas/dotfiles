#!/usr/bin/env bash

# functions.zsh: A collection of useful shell functions for enhanced command-line experience
# To use these functions, source this file in your .zshrc:
# source /path/to/functions.zsh

# Create a new directory and enter it
function mcd() {
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
function fs() {
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

# Open the current dir in Finder (macOS) or file explorer
function o() {
    if [[ "$OSTYPE" == "darwin"* ]]; then
        if [ $# -eq 0 ]; then
            open .;
        else
            open "$@";
        fi;
    elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
        if [ $# -eq 0 ]; then
            xdg-open .;
        else
            xdg-open "$@";
        fi;
    else
        echo "Unsupported operating system"
    fi
}

# Check for connection
function check_internet() {
    ping -c 1 google.com >/dev/null 2>&1
    return $?
}

# Perform system update with enhanced error handling
function update() {
    echo "Starting system update..."

    # Check internet connectivity
    if ! check_internet; then
        echo "Error: No internet connection. Aborting update."
        return 1
    fi

    # Check sudo privileges
    sudo -v || { echo "Error: Failed to get sudo privileges. Aborting update."; return 1; }

    # Parse arguments
    local update_all=true
    local update_macos=false
    local update_brew=false
    local update_mas=false
    local update_omz=false

    while [[ $# -gt 0 ]]; do
        case $1 in
            --macos) update_macos=true; update_all=false ;;
            --brew) update_brew=true; update_all=false ;;
            --mas) update_mas=true; update_all=false ;;
            --omz) update_omz=true; update_all=false ;;
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
        brew doctor || { echo "Error: Brew doctor check failed."; return 1; }
        brew update || { echo "Error: Brew update failed."; return 1; }
        brew outdated
        brew upgrade || { echo "Error: Brew upgrade failed."; return 1; }
        brew outdated --cask
        brew upgrade --cask || { echo "Error: Brew cask upgrade failed."; return 1; }
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

# Extract various archive formats
function extract() {
    if [ -f "$1" ] ; then
        case $1 in
            *.tar.bz2)   tar xjf "$1"     ;;
            *.tar.gz)    tar xzf "$1"     ;;
            *.bz2)       bunzip2 "$1"     ;;
            *.rar)       unrar e "$1"     ;;
            *.gz)        gunzip "$1"      ;;
            *.tar)       tar xf "$1"      ;;
            *.tbz2)      tar xjf "$1"     ;;
            *.tgz)       tar xzf "$1"     ;;
            *.zip)       unzip "$1"       ;;
            *.Z)         uncompress "$1"  ;;
            *.7z)        7z x "$1"        ;;
            *)     echo "'$1' cannot be extracted via extract()" ;;
        esac
    else
        echo "'$1' is not a valid file"
    fi
}

# Generate a random password
function genpass() {
    local length=${1:-16}
    LC_ALL=C tr -dc 'A-Za-z0-9!@#$%^&*()_+' </dev/urandom | head -c "$length"
    echo
}

# Show most used commands
function topcmds() {
  local num=${1:-10} # Default to showing top 10 commands
  history | awk '{CMD[$2]++; count++;} END {for (a in CMD) print CMD[a], CMD[a]/count*100 "%", a;}' | sort -nr | head -n "$num"
}

function empty() {
    local permanent_delete=false
    local dry_run=false
    local dir

    # Parse flags and arguments
    while [[ $# -gt 0 ]]; do
        case "$1" in
            -r|--remove)
                permanent_delete=true
                shift
                ;;
            -d|--dry-run)
                dry_run=true
                shift
                ;;
            -*)
                echo "Unknown flag: $1"
                echo "Usage: empty_dir [-d|--delete] [--dry-run] <directory_path>"
                return 1
                ;;
            *)
                dir="$1"
                shift
                ;;
        esac
    done

    # Ensure a directory argument is provided
    if [ -z "$dir" ]; then
        echo "Usage: empty_dir [-d|--delete] [--dry-run] <directory_path>"
        return 1
    fi

    # Resolve the directory path and validate it
    dir=$(realpath "$dir" 2>/dev/null)
    if [ ! -d "$dir" ]; then
        echo "Error: '$dir' is not a valid directory"
        return 1
    fi

    # Confirm the directory is not empty
    if [ -z "$(ls -A "$dir" 2>/dev/null)" ]; then
        echo "$dir already empty."
        return 0
    fi

    # Dry run: list the contents to be deleted/moved
    if $dry_run; then
        echo "Dry run: The following files and directories would be removed from '$dir':"
        ls -A "$dir"
        return 0
    fi

    # Handle permanent deletion
    if $permanent_delete; then
        rm -rf "$dir"/*
        echo "$dir has been emptied"
        return 0
    fi

    # Default: Move contents to Trash if possible
    if command -v trash-put >/dev/null 2>&1; then
        trash-put "$dir"/* 2>/dev/null
        echo "$dir has been emptied"
    elif [ -d ~/.Trash ]; then
        mv "$dir"/* ~/.Trash/ 2>/dev/null
        echo "Directory '$dir' has been emptied (contents moved to Trash)."
    else
        echo "Trash utility not found. Permanently deleting contents..."
        rm -rf "$dir"/*
        echo "Directory '$dir' has been emptied (contents permanently deleted)."
    fi

    return 0
}
