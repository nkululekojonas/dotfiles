#!/bin/bash

# install.sh: This script installs homebrew 
# Author: Nkululeko Jonas
# Date: 16-03-2025

# Check if Homebrew is already installed
if ! command -v brew &> /dev/null; then
    echo "Installing Homebrew"
    if ! /usr/bin/env bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"; then
        echo "Failed to install Homebrew"
        exit 1
    fi
else
    echo "Homebrew is already installed."
fi

# Update the shell
eval "$(brew shellenv)"

# Set Brewfile location
DOTFILES="${HOME}/dotfiles"
BREWFILE="${DOTFILES}/homebrew/Brewfile"

# Attempt to install dependencies
if [ -f "$BREWFILE" ]; then
    echo "Installing Homebrew dependencies from Brewfile"
    if ! brew bundle --file="$BREWFILE"; then
        echo "Homebrew bundle installation failed. You can try running:"
        echo "  brew bundle --file=$BREWFILE"
        exit 1
    fi
else
    echo "Warning: Brewfile not found at $BREWFILE. Skipping dependencies."
fi

# Exit 
exit 0
