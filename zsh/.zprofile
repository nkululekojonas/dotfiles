# Set up Homebrew environment if brew command is available

if command -v brew > /dev/null; then
    # If brew is already in PATH
    brew_path=$(command -v brew)
    eval "$($brew_path shellenv)"
else
    # If not in PATH, check standard locations based on architecture
    local arch_name="$(uname -m)"
    local brew_prefix

    # Determine potential Homebrew prefix
    if [ "${arch_name}" = "x86_64" ]; then
        brew_prefix="/usr/local" # Standard Intel location
    else
        brew_prefix="/opt/homebrew" # Standard Apple Silicon location
    fi

    # Check if brew executable exists at the determined prefix
    if [ -x "${brew_prefix}/bin/brew" ]; then
        eval "$(${brew_prefix}/bin/brew shellenv)"
    else
        echo "Error: brew command not found in PATH or standard locations." >&2
    fi

    # Clean up local variable
    unset brew_prefix arch_name 
fi
