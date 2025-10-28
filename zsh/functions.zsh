# .functionsrc      : Useful Shell Functions Portable Across Bash and Zsh
# Author            : Nkululeko Jonas
# Date              : 23-10-2023

# --- LS Configuration ---

# Remove Any Previous Alias Definitions
unalias ls l ll lsd 2>/dev/null

# Override Builtin 'ls'
ls()   { command ls $colorflag "$@"; }

# Useful Colorful 'ls' Helpers
l()    { command ls -AFlh $colorflag "$@"; }
ll()   { command ls -aFlh $colorflag "$@"; }

# Directory Listing
l.()   { command ls -AFdlh $colorflag .* "$@"; }

# List only directories (Zsh-specific glob pattern)
if [[ -n ${ZSH_VERSION-} ]]; then
    lsd() { command ls -lF ${colorflag} -d *(/) "$@"; }
else
    lsd() { command ls -lF ${colorflag} "$@" | grep --color=never "^d"; }
fi

# --- Directory Management ---

# Open Current Directory 
o() {
	if [ $# -eq 0 ]; then
		open .;
	else
		open "$@";
	fi;
}

# Change Working Directory To The Top-Most Finder Window Location (Short for `cdfinder`)
cdf() { 
	cd "$(osascript -e 'tell app "Finder" to POSIX path of (insertion location as alias)')";
}

# Create A New Directory And Enter It
mcd() {
    if [ $# -eq 0 ]; then
        echo "Error: No directory name provided"
        return 1
    fi
    if mkdir -p "$@"; then
        cd "$_" || return 1
    else
        echo "Error: Failed to create directory"
        return 1
    fi
}

# --- File System Utilities ---

# Determine Size Of A File Or Total Size Of A Directory
fs() {
    if command -v gdu >/dev/null 2>&1; then
        local du_cmd="gdu"
    else
        local du_cmd="du"
    fi

    if $du_cmd -b /dev/null > /dev/null 2>&1; then
        local arg=-sbh;
    else
        local arg=-sh;
    fi
    if [[ -n "$*" ]]; then
        $du_cmd $arg -- "$@";
    else
        $du_cmd $arg .[^.]* ./*;
    fi;
}

# --- Environment Info ---

# Print Info About The Enviroment Accepts Aguments
uinfo() {
    local default_info=(SHELL TERM USER HOME PWD)

    # Append user-provided arguments if any
    if [[ $# -gt 0 ]]; then
        default_info+=("$@")
    fi

    local arg
    for arg in "${default_info[@]}"; do 
        # Use correct indirect expansion for Bash and Zsh
        if [[ -n ${BASH_VERSION-} ]]; then
            printf "%-15s: %s\n" "$arg" "${!arg:-No value assigned}"
        else
            printf "%-15s: %s\n" "$arg" "${(P)arg:-No value assigned}"
        fi
    done
}

# --- System Update ---

# Perform system update with enhanced error handling
update() {
    # Check sudo privileges
    sudo -v || { echo "Error: Failed to get sudo privileges. Aborting update."; return 1; }

    # Parse arguments
    local update_all=true
    local update_mas=false
    local update_omz=false
    local update_brew=false
    local update_macos=false

    while [[ $# -gt 0 ]]; do
        case $1 in
            --mas) update_mas=true; update_all=false ;;
            --omz) update_omz=true; update_all=false ;;
            --brew) update_brew=true; update_all=false ;;
            --macos) update_macos=true; update_all=false ;;
            *) echo "Unknown option: $1"; return 1 ;;
        esac
        shift
    done

    # macOS Software update
    if $update_all || $update_macos; then
        echo "Updating macOS software..."
        sudo softwareupdate -i -a || { echo "Error: macOS software update failed."; return 1; }
    fi

    # Homebrew update
    if ($update_all || $update_brew) && command -v brew &> /dev/null; then
        echo "Updating Homebrew..."
        brew cu -facy || { echo "Error: Brew upgrade outdated apps failed"; return 1; } 
        brew upgrade || { echo "Error: Brew upgrade failed."; return 1; }
        brew cleanup || { echo "Error: Brew cleanup failed."; return 1; }
        brew autoremove || { echo "Error: Brew autoremove failed."; return 1; }
    elif $update_brew; then
        echo "Warning: Homebrew is not installed."
    fi

    # Mac App Store updates
    if ($update_all || $update_mas) && command -v mas &> /dev/null; then
        echo "Updating Mac App Store apps..."
        mas outdated
        mas upgrade || { echo "Error: Mac App Store upgrade failed."; return 1; }
    elif $update_mas; then
        echo "Warning: mas-cli (Mac App Store CLI) is not installed."
    fi

    # Oh My Zsh update
    if ($update_all || $update_omz) && command -v omz &> /dev/null; then
        echo "Updating Oh My Zsh..."
        omz update || { echo "Error: Oh My Zsh update failed."; return 1; }
    elif $update_omz; then
        echo "Warning: Oh My Zsh is not installed."
    fi

    echo "All updates completed successfully!"
}

# --- NVM (Node Version Manager) Configuration ---

if [[ $- == *i* ]]; then

    # Setup XDG Compliant Path
    export NVM_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/nvm"
    mkdir -p "$NVM_DIR" "${XDG_CONFIG_HOME:-$HOME/.config}/npm"

    lazy_load_nvm() {
        unset -f nvm node npm npx yarn pnpm corepack
        [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
        [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
    }

    # Placeholder functions for lazy loading
    nvm() { lazy_load_nvm; nvm "$@"; }
    node() { lazy_load_nvm; node "$@"; }
    npm() { lazy_load_nvm; npm "$@"; }
    npx() { lazy_load_nvm; npx "$@"; }
    yarn() { lazy_load_nvm; yarn "$@"; }
    pnpm() { lazy_load_nvm; pnpm "$@"; }
    corepack() { lazy_load_nvm; corepack "$@"; }

fi
