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

# Perform system update
function sysupdate() {
    echo "Updating system..."
    sudo -v || { echo "Failed to get sudo privileges"; return 1; }
    
    sudo softwareupdate -i -a || { echo "macOS update failed"; return 1; }

    echo "\nUpdating Homebrew..."
    brew doctor || { echo "Brew doctor check failed"; return 1; }
    brew update || { echo "Brew update failed"; return 1; }
    brew upgrade --formula brew || { echo "Homebrew upgrade failed"; return 1; }
    brew outdated
    brew upgrade || { echo "Brew upgrade failed"; return 1; }
    brew outdated --cask
    brew upgrade --cask || { echo "Brew cask upgrade failed"; return 1; }
    brew cleanup || { echo "Brew cleanup failed"; return 1; }
    brew autoremove || { echo "Brew autoremove failed"; return 1; }

    echo "\nUpdating Mac App Store apps..."
    mas outdated
    mas upgrade || { echo "Mac App Store upgrade failed"; return 1; }

    if command -v omz &> /dev/null; then
        echo "\nUpdating Oh My Zsh..."
        omz update || { echo "Oh My Zsh update failed"; return 1; }
    fi

    echo "\nAll updates completed successfully!"
}
