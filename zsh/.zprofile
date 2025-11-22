# --- Setup Homebrew ---
# Check Standard Arm Path
if [ -x "/opt/homebrew/bin/brew" ]
then
    eval "$(/opt/homebrew/bin/brew shellenv)"
else
    echo "Warning: Homebrew not found." >&2
fi
