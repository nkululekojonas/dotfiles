# Set up Homebrew environment

local brew_executable
if brew_executable=$(command -v brew); then
    eval "$($brew_executable shellenv)"
else
    local arch_name="$(uname -m)"
    local brew_prefix
    if [ "${arch_name}" = "x86_64" ]; then
        brew_prefix="/usr/local"
    else
        brew_prefix="/opt/homebrew"
    fi

    if [ -x "${brew_prefix}/bin/brew" ]; then
        export HOMEBREW_PREFIX="${brew_prefix}" # Export for other scripts
        eval "$(${brew_prefix}/bin/brew shellenv)"
    else
        echo "Warning: brew command not found." >&2
    fi

    unset brew_prefix arch_name
fi
unset brew_executable
