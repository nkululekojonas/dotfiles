#!/usr/bin/env bash

set -euo pipefail

# Define the source (dotfiles) and target (.config) directories
DOTFILES_DIR="${HOME}/dotfiles"
CONFIG_DIR="${HOME}/.config"

# List of files/directories to symlink
files=("git/gitconfig" "tmux/tmux.conf" "vim/vimrc" "zed/settings.json" "zsh/.zshenv" "zsh/.zshrc" "zsh/aliases.zsh" "zsh/functions.zsh")

# Flag for dry run
DRY_RUN=false

# Function to create symlink
create_symlink() {
    local src="${DOTFILES_DIR}/$1"
    local dest="${CONFIG_DIR}/$1"
    local dest_dir
    dest_dir=$(dirname "$dest")

    # Dry run: show what would happen
    if [ "$DRY_RUN" = true ]; then
        if [ ! -e "$src" ]; then
            echo "[DRY RUN] Error: Source file $src does not exist."
        else
            echo "[DRY RUN] Would create symlink: $dest -> $src"
        fi
        return
    fi

    # Check if source file exists
    if [ ! -e "$src" ]; then
        echo "Error: Source file $src does not exist." >&2
        return 1
    fi

    # Create destination directory if it doesn't exist
    mkdir -p "$dest_dir"

    # Create symlink
    if ln -sf "$src" "$dest"; then
        echo "Created symlink: $dest -> $src"
    else
        echo "Error: Failed to create symlink for $1" >&2
        return 1
    fi
}

# Main script
if [[ "${1:-}" == "--dry-run" ]]; then
    DRY_RUN=true
    echo "Running in dry-run mode. No changes will be made."
fi

# Validate DOTFILES_DIR existence
if [ ! -d "$DOTFILES_DIR" ]; then
    echo "Error: DOTFILES_DIR ($DOTFILES_DIR) does not exist. Please set the correct path." >&2
    exit 1
fi

echo "Creating symlinks from $DOTFILES_DIR to $CONFIG_DIR"

# Create symlinks for files
for file in "${files[@]}"; do
    create_symlink "$file"
done

echo "Symlink creation complete."

# Check Homebrew
if ! command -v brew &>/dev/null; then
    if [ "$DRY_RUN" = true ]; then
        echo "[DRY RUN] Would install Homebrew."
    else
        echo "Installing Homebrew"
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" || {
            echo "Error: Failed to install Homebrew" >&2
            exit 1
        }
    fi
else
    echo "Homebrew is already installed."
fi

# Run Brewfile
BREWFILE="${DOTFILES_DIR}/Brewfile"
if [ -f "$BREWFILE" ]; then
    if [ "$DRY_RUN" = true ]; then
        echo "[DRY RUN] Would run: brew bundle --file=$BREWFILE"
    else
        echo "Installing Homebrew dependencies from Brewfile"
        brew bundle --file="$BREWFILE"
    fi
else
    echo "Warning: Brewfile not found at $BREWFILE. Skipping Homebrew dependencies."
fi

echo "Setup complete!"