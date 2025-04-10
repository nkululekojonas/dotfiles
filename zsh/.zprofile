# ~/.zprofile
# Set up Homebrew environment if brew command is available

local brew_executable
if command -v brew >/dev/null 2>&1; then
    # If brew is already in PATH (e.g., from /etc/paths), use it
    brew_executable=$(command -v brew)
    eval "$($brew_executable shellenv)"
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
        brew_executable="${brew_prefix}/bin/brew"
        eval "$($brew_executable shellenv)"
    else
        # Optional: Warn if brew couldn't be found
        # echo "WARN: brew command not found in PATH or standard locations. Cannot configure Homebrew environment." >&2
    fi
    unset brew_prefix # Clean up local variable
fi
unset brew_executable arch_name # Clean up local variables