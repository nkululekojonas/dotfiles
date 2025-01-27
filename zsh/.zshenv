# Set XDG environment variables
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"
export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
export XDG_STATE_HOME="${XDG_STATE_HOME:-$HOME/.local/state}"
export XDG_RUNTIME_DIR="${XDG_RUNTIME_DIR:-$HOME/.local/run}"

# Ensure XDG_RUNTIME_DIR has the correct permissions
if [[ ! -d "$XDG_RUNTIME_DIR" ]]; then
    mkdir -p "$XDG_RUNTIME_DIR" && chmod 0700 "$XDG_RUNTIME_DIR"
fi

# Zsh configuration directory
export ZDOTDIR="$XDG_CONFIG_HOME/zsh"

# Create required directories function with error handling
function ensure_xdg_dirs() {
    local dirs=(
        "$ZDOTDIR"
        "$XDG_CONFIG_HOME/python"
        "$XDG_CONFIG_HOME/vim"
        "$XDG_CACHE_HOME/zsh"
    )
    for dir in "${dirs[@]}"; do
        if [[ ! -d "$dir" ]]; then
            if ! mkdir -p "$dir"; then
                echo "Error: Failed to create directory '$dir'. Check permissions or disk space." >&2
                return 1
            fi
        fi
    done
}
ensure_xdg_dirs || exit 1  # Exit if directory creation fails

# PATH configuration
local extra_paths=(
    "$HOME/bin"
    "$HOME/Developer/Playgrounds"
)
for path_entry in "${extra_paths[@]}"; do
    if [[ -d "$path_entry" && ":$PATH:" != *":$path_entry:"* ]]; then
        PATH="$path_entry:$PATH"
    fi
done

# Set DOT  only if ~/dotfiles exists otherwise clone github dotfiles repo to $HOME
if [[ -d "${HOME}/dotfiles" ]]; then
    # set dotfiles variable for easier access
    export DOT="${HOME}/dotfiles"
else
    echo "Warning: ~/dotfiles not found"
fi 

# Default applications
export EDITOR="vim"
export VISUAL="vim"
export PAGER="less"

# Less configuration
export LESS="-R -i -g -c -W -M -J"  # Raw control chars, case-insensitive search, and more
export LESSHISTFILE="-"              # Disable less history file

# Locale settings
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# Python configuration
export PYTHONSTARTUP="$XDG_CONFIG_HOME/python/pythonrc"
export PYTHONHISTORY="$XDG_CONFIG_HOME/python/history"

# Vim XDG configuration
export VIMINIT='let $MYVIMRC="$XDG_CONFIG_HOME/vim/vimrc" | source $MYVIMRC'

# Node.js configuration
export NVM_DIR="$XDG_CONFIG_HOME/nvm"
export NPM_CONFIG_USERCONFIG="$XDG_CONFIG_HOME/npm/npmrc"

# Lazy-load NVM to improve shell startup time
function load_nvm() {
    unset -f nvm node npm  # Remove the lazy-loading function
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # Load NVM
    "$@"  # Execute the given command (e.g., nvm, node, npm)
}

# Lazy-loading aliases for NVM commands
alias nvm="load_nvm nvm"
alias node="load_nvm node"
alias npm="load_nvm npm"
