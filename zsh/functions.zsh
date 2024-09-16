#!/usr/bin/env bash

# Create a new directory and enter it
function mcd() {
    mkdir -p "$@" && cd "$_" || exit;
}

# Determine size of a file or total size of a directory
function fs() {
    if du -b /dev/null > /dev/null 2>&1; then
        local arg=-sbh;
    else
        local arg=-sh;
    fi
    if [[ -n "$*" ]]; then
        du $arg -- "$*";
    else
        du $arg .[^.]* ./*;
    fi;
}

# Open the current dir in Finder(MacOS)
function o() {
    if [ $# -eq 0 ]; then
        open .;
    else
        open "$@";
    fi;
}

# Perform system update with enhanced error handling
function sysupdate() {
    echo "Starting system update..."

    # Check sudo privileges
    sudo -v || { echo "Error: Failed to get sudo privileges. Aborting update."; return 1; }

    # macOS Software update
    echo "Updating macOS software..."
    sudo softwareupdate -i -a || { echo "Error: macOS software update failed."; return 1; }

    # Homebrew update
    if command -v brew &> /dev/null; then
        echo "Updating Homebrew..."
        brew doctor || { echo "Error: Brew doctor check failed."; return 1; }
        brew update || { echo "Error: Brew update failed."; return 1; }
        brew outdated
        brew upgrade || { echo "Error: Brew upgrade failed."; return 1; }
        brew outdated --cask
        brew upgrade --cask || { echo "Error: Brew cask upgrade failed."; return 1; }
        brew cleanup || { echo "Error: Brew cleanup failed."; return 1; }
        brew autoremove || { echo "Error: Brew autoremove failed."; return 1; }
    else
        echo "Warning: Homebrew is not installed."
    fi

    # Mac App Store updates
    if command -v mas &> /dev/null; then
        echo "Updating Mac App Store apps..."
        mas outdated
        mas upgrade || { echo "Error: Mac App Store upgrade failed."; return 1; }
    else
        echo "Warning: mas-cli (Mac App Store CLI) is not installed."
    fi

    # Oh My Zsh update
    if command -v omz &> /dev/null; then
        echo "Updating Oh My Zsh..."
        omz update || { echo "Error: Oh My Zsh update failed."; return 1; }
    else
        echo "Warning: Oh My Zsh is not installed."
    fi

    echo "All updates completed successfully!"
}
