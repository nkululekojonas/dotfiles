#!/bin/bash
#
# brew.sh: Install Homebrew and dependencies 
# Author: Nkululeko Jonas

# --- Functions for Clarity ---
info() 
{
    echo "INFO: $1"
}

warn() 
{
    echo "WARN: $1" >&2 # Write warnings to stderr
}

error() 
{
    echo "ERROR: $1" >&2 # Write errors to stderr
    exit 1
}

install_brew()
{
    # Note: The official installer might require user interaction (e.g., password, pressing Enter)
    if /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    then
        info "Homebrew installed successfully."
    else
        error "Homebrew installation failed."
    fi
}

# --- Ensure Homebrew is Installed ---
if ! command -v brew &> /dev/null
then
    info "Homebrew not found. Attempting to install..."
    install_brew

else
    info "Homebrew is already installed."
fi

# Check if brew shellenv needs to be evaluated
if [ -x "/opt/homebrew/bin/brew" ]
then
    info "Configuring Homebrew shell environment..."
    eval "$(/opt/homebrew/bin/brew shellenv)"
else
    error "Brew executable not found at expected location: /opt/homebrew/bin/brew"
fi

BREWFILE="${DOTFILES:-${HOME}/.dotfiles}/brew/Brewfile"

# --- Install Dependencies via Brew Bundle ---
if [ -f "$BREWFILE" ]
then
    info "Installing dependencies from Brewfile: ${BREWFILE}"

    # Run brew bundle install using the specified Brewfile
    if ! brew bundle install --file="$BREWFILE"
    then
        echo "ERROR: Homebrew bundle installation failed." >&2
        echo "You might need to run the command manually to see more details:" >&2
        echo "  brew bundle install --file=\"$BREWFILE\"" >&2
        exit 1
    else
        info "Homebrew dependencies installed successfully."
    fi
else
    warn "Brewfile not found at ${BREWFILE}. Skipping dependency installation."
    exit 0
fi

info "Homebrew setup complete."
exit 0
