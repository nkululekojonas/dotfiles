# XDG Base Directory specification
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"
export XDG_RUNTIME_DIR="$HOME/.local/run"

# Zsh configuration directory
export ZDOTDIR="$XDG_CONFIG_HOME/zsh"

# Create required directories function
function ensure_xdg_dirs() {
    local dirs=(
        "$ZDOTDIR"
        "$XDG_CONFIG_HOME/python"
        "$XDG_CONFIG_HOME/vim"
        "$XDG_CACHE_HOME/zsh"
    )
    for dir in "${dirs[@]}"; do
        [[ ! -d "$dir" ]] && mkdir -p "$dir"
    done
}
ensure_xdg_dirs

# PATH configuration
local extra_paths=(
    "$HOME/bin"
)
for path_entry in "${extra_paths[@]}"; do
    [[ ":$PATH:" != *":$path_entry:"* ]] && PATH="$path_entry:$PATH"
done

# Default applications
export EDITOR="vim"
export VISUAL="vim"
export PAGER="less"

# Less configuration
export LESS="-R -i -g -c -W -M -J"
export LESSHISTFILE="-"

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

# Load NVM
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
