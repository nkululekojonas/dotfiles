#!/bin/bash

q# install.sh: Symlink configuration dotfiles and install dependencies
# Author: Nkululeko Jonas (Optimized based on XDG setup)
# Date: 01-10-2024 (Updated: 2025-05-03)

# --- Configuration ---

# Enable strict error handling: exit on error (-e), undefined variable (-u),
# pipe failure (-o pipefail). Report trace (-x) for debugging if needed.
set -euo pipefail

# Source directory for dotfiles
# Uses environment variable DOTFILES if set, otherwise defaults to ~/dotfiles
DOTFILES="${DOTFILES:-${HOME}/dotfiles}"

# Destination directory for most configuration files (XDG Base Directory)
# Uses environment variable XDG_CONFIG_HOME if set, otherwise defaults to ~/.config
CONFIG_DIR="${XDG_CONFIG_HOME:-${HOME}/.config}"

# List of files/directories to symlink relative to $DOTFILES
# Format: "source/path/in/dotfiles"
# Destination is automatically determined based on XDG standards unless overridden.
files_to_link=(
    "vim/vimrc"         # Target: $CONFIG_DIR/vim/vimrc
    "git/gitconfig"     # Target: $CONFIG_DIR/git/gitconfig
    "git/gitignore"     # Target: $CONFIG_DIR/git/gitignore (Ensure git configured for this)
    "tmux/tmux.conf"    # Target: $CONFIG_DIR/tmux/tmux.conf
    "zsh/.zprofile"     # Target: $CONFIG_DIR/zsh/.zprofile (Uses ZDOTDIR)
    "zsh/.zshenv"       # Target: $CONFIG_DIR/zsh/.zshenv   (Uses ZDOTDIR)
    "zsh/.zshrc"        # Target: $CONFIG_DIR/zsh/.zshrc    (Uses ZDOTDIR)
    "zsh/aliases.zsh"   # Target: $CONFIG_DIR/zsh/aliases.zsh
    "zsh/functions.zsh" # Target: $CONFIG_DIR/zsh/functions.zsh
    "ssh/config"        # Target: $HOME/.ssh/config (Special case)
)

# Homebrew Bundle file location
BREWFILE="${BREWFILE:-${DOTFILES}/homebrew/Brewfile}"

# --- Flags ---
DRY_RUN=false
SKIP_BREW=false
SKIP_MACOS=false
SKIP_SYMLINKS=false

# --- Helper Functions ---

# Log an error message to stderr
error() {
    echo "[ERROR] $1" >&2
}

# Log an informational message to stdout
info() {
    echo "[INFO] $1"
}

# Print usage instructions
usage() {
    echo "Usage: $0 [options]"
    echo "Options:"
    echo "  --dry-run       Show actions without executing."
    echo "  --skip-brew     Skip Homebrew installation and bundling."
    echo "  --skip-macos    Skip running macOS defaults script."
    echo "  --skip-symlinks Skip creating symlinks."
    echo "  -h, --help      Show this help message."
}

# Backup an existing file or directory if it's not already a symlink
backup() {
    local target="$1"
    local backup_target="${target}.bak"

    # Check if the target exists and is not a symlink
    if [[ -e "$target" && ! -L "$target" ]]; then
        if [ "$DRY_RUN" = true ]; then
            info "[DRY RUN] Would backup: '$target' -> '$backup_target'"
        else
            info "Backing up existing '$target' to '$backup_target'"
            # Use -f to overwrite existing backup if necessary
            mv -f "$target" "$backup_target" || { error "Failed to backup '$target'"; return 1; }
        fi
    fi
    return 0
}

# Create a symlink from source to destination
create_symlink() {
    local source_path="$1" # Full path to the source file in dotfiles repo
    local target_path="$2" # Full path to the destination symlink

    local target_dir
    target_dir="$(dirname "$target_path")"

    # Ensure the target directory exists
    if [ "$DRY_RUN" = true ]; then
        if [[ ! -d "$target_dir" ]]; then
            info "[DRY RUN] Would create directory: '$target_dir'"
        fi
    else
        # Create directory if it doesn't exist
        mkdir -p "$target_dir" || { error "Failed to create directory '$target_dir'"; return 1; }
    fi

    # Backup the target if it exists and isn't a symlink
    backup "$target_path" || return 1

    # Check if source file exists
    if [[ ! -e "$source_path" ]]; then
        error "Source file '$source_path' does not exist. Skipping."
        return 1 # Indicate failure
    fi

    # Create the symlink
    if [ "$DRY_RUN" = true ]; then
        info "[DRY RUN] Would create symlink: '$target_path' -> '$source_path'"
    else
        # Use -f to force overwrite if a symlink/file already exists at target
        # Use -n first? No, -f is typical for dotfile managers to ensure link is correct.
        ln -sf "$source_path" "$target_path" || { error "Failed to create symlink '$target_path'"; return 1; }
        info "Created symlink: '$target_path' -> '$source_path'"
    fi
    return 0 # Indicate success
}

# --- Argument Parsing ---
while [[ $# -gt 0 ]]; do
    case "$1" in
        --dry-run) DRY_RUN=true; shift ;;
        --skip-brew) SKIP_BREW=true; shift ;;
        --skip-macos) SKIP_MACOS=true; shift ;;
        --skip-symlinks) SKIP_SYMLINKS=true; shift ;;
        -h|--help) usage; exit 0 ;;
        *) error "Invalid option: $1"; usage; exit 1 ;;
    esac
done

# --- Main Execution ---

# 1. Check if Dotfiles Directory exists
info "Checking for dotfiles directory at '$DOTFILES'..."
if [[ ! -d "$DOTFILES" ]]; then
    error "Dotfiles directory '$DOTFILES' not found. Please clone it or set the DOTFILES environment variable."
    exit 1
fi
info "Dotfiles directory found."

# 2. Create Symlinks
if [ "$SKIP_SYMLINKS" = true ]; then
    info "Skipping symlink creation as requested."
else
    info "Starting symlink creation..."
    info "Source base: '$DOTFILES'"
    info "Target base: '$CONFIG_DIR' (and '$HOME/.ssh' for ssh config)"

    success_count=0
    fail_count=0

    for item in "${files_to_link[@]}"; do
        src="${DOTFILES}/${item}"
        dest=""

        # Determine destination path
        case "$item" in
            ssh/config)
                dest="${HOME}/.ssh/config"
                ;;
            zsh/*)
                # Zsh files go into ZDOTDIR ($CONFIG_DIR/zsh/)
                dest="${CONFIG_DIR}/zsh/$(basename "$item")"
                ;;
            *)
                # Default: place in $CONFIG_DIR maintaining structure
                dest="${CONFIG_DIR}/${item}"
                ;;
        esac

        # Attempt to create the symlink
        if create_symlink "$src" "$dest"; then
            ((success_count++))
        else
            ((fail_count++))
        fi
    done

    info "Symlink creation finished. Success: $success_count, Failed: $fail_count."
    if (( fail_count > 0 )); then
        error "Some symlinks could not be created. Please check the errors above."
        # Decide if this should be a fatal error
        # exit 1
    fi
fi

# 3. Install Homebrew and Bundle
if [ "$SKIP_BREW" = true ]; then
    info "Skipping Homebrew installation and bundling as requested."
else
    info "Starting Homebrew setup..."
    brew_install_script="${DOTFILES}/homebrew/install.sh"

    if [[ ! -f "$brew_install_script" ]]; then
        error "Homebrew install script not found at '$brew_install_script'. Skipping Brew setup."
    else
        if [ "$DRY_RUN" = true ]; then
            info "[DRY RUN] Would run Homebrew install script: '$brew_install_script'"
            info "[DRY RUN] Would run: brew bundle --file='$BREWFILE'"
        else
            info "Running Homebrew install script: '$brew_install_script'"
            if "$brew_install_script"; then
                info "Homebrew install script finished."
                # Check if Brewfile exists before bundling
                if [[ -f "$BREWFILE" ]]; then
                     # Check if brew command exists now
                    if command -v brew &> /dev/null; then
                        info "Running brew bundle install --file='$BREWFILE'..."
                        if brew bundle install --file="$BREWFILE"; then
                            info "Homebrew bundle completed successfully."
                        else
                            error "Homebrew bundle command failed."
                        fi
                    else
                        error "Homebrew command 'brew' not found after running install script. Cannot run bundle."
                    fi
                else
                    info "Brewfile not found at '$BREWFILE'. Skipping brew bundle."
                fi
            else
                error "Homebrew install script failed."
            fi
        fi
    fi
fi

# 4. Apply macOS Defaults
if [ "$SKIP_MACOS" = true ]; then
    info "Skipping macOS defaults configuration as requested."
else
    info "Applying macOS defaults..."
    macos_script="${DOTFILES}/macos/macos-defaults.sh"

    if [[ ! -f "$macos_script" ]]; then
        error "macOS defaults script not found at '$macos_script'. Skipping."
    else
        if [ "$DRY_RUN" = true ]; then
            info "[DRY RUN] Would run macOS defaults script: '$macos_script'"
        else
            info "Running macOS defaults script: '$macos_script'"
            if "$macos_script"; then
                info "macOS defaults script finished successfully."
            else
                error "macOS defaults script failed."
                # Consider if this should be fatal
                # exit 1
            fi
        fi
    fi
fi

# --- Finish ---
info "Setup script finished!"
exit 0
