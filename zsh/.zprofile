# --- Setup Homebrew ---
if command -v brew >/dev/null 2>&1; then
    eval "$(brew shellenv)"
else
    # Check standard x86 and arm paths
    for prefix in /opt/homebrew /usr/local; do
        if [ -x "$prefix/bin/brew" ]; then
            eval "$($prefix/bin/brew shellenv)"
            break
        fi
    done
    if ! command -v brew >/dev/null 2>&1; then
        echo "Warning: Homebrew not found." >&2
    fi
fi
