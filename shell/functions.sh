# .functionsrc      : Useful Shell Functions Portable Across Bash and Zsh
# Author            : Nkululeko Jonas
# Date              : 23-10-2023

# --- LS Configuration ---
export CLICOLOR=1
export LSCOLORS=Gxfxcxdxbxegedabagacad

unalias ls l ll lsd 2>/dev/null

colorflag=""
if ls --color=auto / &> /dev/null 2>&1
then
    colorflag="--color=auto"
    export LS_COLORS='di=1;36:ln=35:so=32:pi=33:ex=31:bd=34;46:cd=34;43:su=30;41:sg=30;46:tw=30;42:ow=30;43'
fi

# Override Builtin 'ls'
l()    { command ls -AFLlh ${colorflag} "$@"; }
ll()   { command ls -aFLlh ${colorflag} "$@"; }
ls()   { command ls ${colorflag} "$@"; }

# Directory Listing (Zsh-specific glob pattern)
if [[ -n ${ZSH_VERSION-} ]]
then
    eval 'l.()  { command ls -AFLdlh ${colorflag} .* "$@"; }'
    eval 'lsd() { command ls -lF "${colorflag}" -d *(/) "$@"; }'
else
    lsd()  { command ls -lF "${colorflag}" "$@" | grep --color=never "^d"; }
fi

# --- Directory Management ---

# Open Current Directory 
op() 
{
    if ! command -v open &> /dev/null
    then
        echo "Error: 'open' command not found (macOS only)"
        return 1
    fi

    if [ $# -eq 0 ]
    then
        open .
    else
        open "$@"
    fi
}

# Change Working Directory To The Top-Most Finder Window Location
cdf() 
{
    if ! command -v osascript &> /dev/null
    then
        echo "Error: 'osascript' not found (macOS only)"
        return 1
    fi

    local finder_path
    finder_path=$(osascript -e 'tell app "Finder" to POSIX path of (insertion location as alias)' 2>/dev/null)
    
    if [[ -z "$finder_path" ]]
    then
        echo "Error: Could not get Finder location. Is Finder running?"
        return 1
    fi

    cd "$finder_path" || return 1
}

# Create A New Directory And Enter It
mcd() 
{
    if [ $# -eq 0 ]
    then
        echo "Error: No directory name provided"
        return 1
    fi

    local target_dir="$1"
    
    if ! mkdir -p "$target_dir"
    then
        echo "Error: Failed to create directory '$target_dir'"
        return 1
    fi

    cd "$target_dir" || return 1
}

# --- File System Utilities ---
df() { command df -h "$@"; }
du() { command du -sh "$@"; }

# Determine Size Of A File Or Total Size Of A Directory
fs() 
{
    if command -v gdu &> /dev/null
    then
        local du_cmd="gdu"
    else
        local du_cmd="du"
    fi

    if $du_cmd -b /dev/null &> /dev/null 
    then
        local arg=-sbh;
    else
        local arg=-sh;
    fi

    if [[ $# -gt 0 ]]
    then
        $du_cmd $arg -- "$@";
    else
        $du_cmd $arg .[^.]* ./*;
    fi;
}

# --- Environment Info ---

# Print Info About The Enviroment Accepts Aguments
uinfo() 
{
    local default_info=(SHELL TERM USER HOME PWD)

    # Append user-provided arguments if any
    if [[ $# -gt 0 ]]
    then
        default_info+=("$@")
    fi

    local arg
    for arg in "${default_info[@]}"
    do 
        # Use correct indirect expansion for Bash and Zsh
        if [[ -n ${BASH_VERSION-} ]]
        then
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
        sudo softwareupdate -i -a || echo "Warning: macOS software update had issues"
    fi

    # Homebrew update
    if ($update_all || $update_brew) && command -v brew &> /dev/null; then
        echo "Updating Homebrew..."
        
        # Only run brew cu if the tap is installed
        if brew tap | grep -q "buo/cask-upgrade"; then
            brew cu -facy || echo "Warning: brew cu failed, continuing..."
        fi
        
        brew upgrade || echo "Warning: brew upgrade had issues"
        brew cleanup || echo "Warning: brew cleanup had issues"
        brew autoremove || echo "Warning: brew autoremove had issues"
    elif $update_brew; then
        echo "Warning: Homebrew is not installed."
    fi

    # Mac App Store updates
    if ($update_all || $update_mas) && command -v mas &> /dev/null; then
        echo "Updating Mac App Store apps..."
        mas outdated
        mas upgrade || echo "Warning: Mac App Store upgrade had issues"
    elif $update_mas; then
        echo "Warning: mas-cli (Mac App Store CLI) is not installed."
    fi

    # Oh My Zsh update
    if ($update_all || $update_omz) && command -v omz &> /dev/null; then
        echo "Updating Oh My Zsh..."
        omz update || echo "Warning: Oh My Zsh update had issues"
    elif $update_omz; then
        echo "Warning: Oh My Zsh is not installed."
    fi

    echo "Update process completed!"
}

# Open last edited file in vim
vlast()
{
    local last_file
    last_file=$(ls -t | head -1)
    
    if [[ -z "$last_file" ]]
    then
        echo "Error: No files in current directory"
        return 1
    fi
    
    vim "$last_file"
}

# --- NVM (Node Version Manager) Configuration ---
if [[ $- == *i* ]]
then

    # Setup XDG Compliant Path
    export NVM_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/nvm"
    mkdir -p "$NVM_DIR" "${XDG_CONFIG_HOME:-$HOME/.config}/npm"

    lazy_load_nvm() 
    {
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