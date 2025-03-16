#!/bin/bash

# install.sh: symlink configuration dotfiles and install homebrew
# Author: Nkululeko Jonas
# Date: 01-10-2024

# Enable strict error handling
set -euo pipefail

# Set Flags
DRY_RUN=false
SKIP_BREW=false
SKIP_MACOS=false
SKIP_SYMLINKS=false

# List of files/directories to symlink
files=(
    "vim/vimrc"
    "ssh/config"
    "git/gitconfig"
    "git/gitignore"
    "tmux/tmux.conf"
    "zsh/.zprofile"
    "zsh/.zshenv"
    "zsh/.zshrc"
    "zsh/aliases.zsh" 
    "zsh/functions.zsh"
)

# Log errors
error() {
    echo "Error: $1" >&2
}

# Function to print usage
usage() {
    echo "Usage: $0 [options]"
    echo "Options:"
    echo "  --dry-run       Show actions without executing"
    echo "  --skip-brew     Skip Homebrew installation"
    echo "  --skip-macos    Skip MacOS Defaults installation"
    echo "  --skip-symlinks Skip creating symlinks"
    echo "  -h, --help      Show this help message"
}

# Parse command-line arguments
while [[ $# -gt 0 ]]; do
    case "$1" in
        --dry-run) DRY_RUN=true ;;
        --skip-brew) SKIP_BREW=true ;;
        --skip-macos) SKIP_MACOS=true;;
        --skip-symlinks) SKIP_SYMLINKS=true ;;
        -h|--help) usage; exit 0;;
        *) error "Invalid option: $1"; usage; exit 1;;
    esac
    shift
done

# Backup existing files that aren't symlinks
backup() {
    local file="$1"
    if [ -e "$file" ] && [ ! -L "$file" ]; then
        if [ "$DRY_RUN" = true ]; then
            echo "[DRY RUN] Would backup: $file -> ${file}.bak"
        else
            mv "$file" "${file}.bak"
            echo "[BACKED UP]: $file -> ${file}.bak"
        fi
    fi
}

# Source (dotfiles) and target directories
DOTFILES="${DOTFILES:-${HOME}/dotfiles}"
ZSHENV_DEST="${ZSHENV_DEST:-/etc/zshenv}"
CONFIG_DIR="${XDG_CONFIG_HOME:-${HOME}/.config}"

# Create symnlinks
symlink() {
    # Set source and destination targets
    local src="${DOTFILES}/$1"
    local dest

    # Override destination for specific files
    if [ "$1" = "zsh/.zshenv" ]; then
        dest="$ZSHENV_DEST"
    elif [ "$1" = "ssh/config" ]; then
        dest="$HOME/.ssh/config"
    else
        dest="${CONFIG_DIR}/$1"
    fi

    # Get the file destination directory 
    local dest_dir="${dest%/*}"

    # Check if destination directory exists
    mkdir -p "$dest_dir"
    backup "$dest"

    # Check if source file exists
    if [ ! -e "$src" ]; then
        error "Source file $src does not exist."
        return 1
    fi

    # Check for DRY RUN
    if [ "$DRY_RUN" = true ]; then
        echo "[DRY RUN] Would create symlink: $dest -> $src"
        return 0
    fi

    # Create the symlink; use sudo for /etc/zshenv if necessary
    if [ "$1" = "zsh/.zshenv" ] && [ ! -w "$dest_dir" ]; then
        echo "Requesting sudo access to link .zshenv..."
        sudo ln -sf "$src" "$dest"
    else 
        ln -sf "$src" "$dest"
    fi

    # Report symlink creation
    echo "[CREATED SYMLINK]: $dest -> $src"
}

# Check if dotfiles directory exists
if [ ! -d "$DOTFILES" ]; then
    error "'$DOTFILES' does not exist."
    exit 1
fi

# Check symlink flag
if [ "$SKIP_SYMLINKS" = true ]; then
    # Report Skip
    echo "Skipping symlink creation."
else
    # Symlink files
    echo "Creating symlinks from $DOTFILES to $CONFIG_DIR"
    for file in "${files[@]}"; do
        symlink "$file"
    done
    echo "Symlink creation complete."
fi

# Check for Homebrew
if [ "$SKIP_BREW" = true ]; then
    echo "Skipping Homebrew installation."
else 
    if [ "$DRY_RUN" = true ]; then
        echo "[DRY RUN]: Would run '${DOTFILES}/homebrew/install.sh' for homebrew instillation."
        echo "[DRY RUN]: Would run 'brew bundle --file=${BREWFILE:-$DOTFILES/homebrew/Brewfile}'"
    else 
        # Install Homebrew
        "${DOTFILES}/homebrew/install.sh" || error "Failed to install Homebrew"
    fi 
fi 

# Install MacOS defaults
if [ "$SKIP_MACOS" = true ]; then
    echo "Skipping MacOS Defaults installation."
else 
    if [ "$DRY_RUN" = true ]; then
        echo "[DRY RUN]: Would run '${DOTFILES}/macos/macos-defaults.sh'"
    else 
        # Insall MacOS Defaults
        "${DOTFILES}/macos/macos-defaults.sh" || { error "Failed to install MacOS Defaults."; return 4; }
    fi 
fi 

# Finish Gracefully.
echo "Setup complete!"

exit 0
