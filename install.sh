#!/bin/bash

# Define the source (dotfiles) and target (.config) directories
DOTFILES_DIR="$HOME/dotfiles"
CONFIG_DIR="$HOME/.config"

# List of files/directories to symlink
files=("vim/vimrc" "git/gitconfig" "tmux/tmux.conf")

# Function to create symlink
create_symlink() {
    local src="$DOTFILES_DIR/$1"
    local dest="$CONFIG_DIR/$1"
    local dest_dir=$(dirname "$dest")

    # Check if source file exists
    if [ ! -e "$src" ]; then
        echo "Error: Source file $src does not exist."
        return 1
    fi

    # Create destination directory if it doesn't exist
    mkdir -p "$dest_dir"

    # Create symlink
    if ln -sf "$src" "$dest"; then
        echo "Created symlink: $dest -> $src"
    else
        echo "Error: Failed to create symlink for $1"
    fi
}

# Main script
echo "Creating symlinks from $DOTFILES_DIR to $CONFIG_DIR"

for file in "${files[@]}"; do
    create_symlink "$file"
done

echo "Symlink creation complete."
