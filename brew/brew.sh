#!/usr/bin/env bash

# install.sh: Installs Homebrew and dependencies from a Brewfile.
# Author: Nkululeko Jonas

# --- Configuration ---
DOTFILES_DIR="${HOME}/dotfiles"
BREWFILE_PATH="${DOTFILES_DIR}/homebrew/Brewfile"

# --- Functions for Clarity ---
info() {
    echo "INFO: $1"
}

warn() {
    echo "WARN: $1" >&2 # Write warnings to stderr
}

error() {
    echo "ERROR: $1" >&2 # Write errors to stderr
    exit 1
}

# --- Ensure Homebrew is Installed ---
if ! command -v brew &> /dev/null; then
    info "Homebrew not found. Attempting to install..."
    # Note: The official installer might require user interaction (e.g., password, pressing Enter)
    if /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"; then
        info "Homebrew installed successfully."
    else
        error "Homebrew installation failed."
    fi
else
    info "Homebrew is already installed."
fi

# --- Set up Homebrew Environment ---
# Ensure brew command and its paths are available in this script's environment
# Correct path depends on CPU architecture (Intel vs Apple Silicon)
ARCH_NAME="$(uname -m)"
if [ "${ARCH_NAME}" = "x86_64" ]; then
    # Intel Macs
    HOMEBREW_PREFIX="/usr/local"
else
    # Apple Silicon Macs
    HOMEBREW_PREFIX="/opt/homebrew"
fi

# Check if brew shellenv needs to be evaluated
if [ -x "${HOMEBREW_PREFIX}/bin/brew" ]; then
    info "Configuring Homebrew shell environment..."
    eval "$(${HOMEBREW_PREFIX}/bin/brew shellenv)"
else
    error "Brew executable not found at expected location: ${HOMEBREW_PREFIX}/bin/brew"
fi


# --- Install Dependencies via Brew Bundle ---
if [ -f "$BREWFILE_PATH" ]; then
    info "Updating Homebrew..."
    if ! brew update --quiet; then
        warn "Brew update failed, continuing bundle install anyway..."
    fi

    info "Installing dependencies from Brewfile: ${BREWFILE_PATH}"
    # Run brew bundle install using the specified Brewfile
    if ! brew bundle install --file="$BREWFILE_PATH"; then
        # Provide specific retry instructions on failure
        echo "ERROR: Homebrew bundle installation failed." >&2
        echo "You might need to run the command manually to see more details:" >&2
        echo "  brew bundle install --file=\"$BREWFILE_PATH\"" >&2
        exit 1
    else
        info "Homebrew dependencies installed successfully."
    fi
else
    warn "Brewfile not found at ${BREWFILE_PATH}. Skipping dependency installation."
    # Exit cleanly if no Brewfile is found, as there's nothing more to do.
    exit 0
fi

info "Homebrew setup complete."
exit 0
