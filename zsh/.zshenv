# --- XDG Base Directory Specification Compliance ---
export XDG_CACHE_HOME="${XDG_CACHE_HOME:-"${HOME}/.cache"}"
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-"${HOME}/.config"}"
export XDG_DATA_HOME="${XDG_DATA_HOME:-"${HOME}/.local/share"}"
export XDG_STATE_HOME="${XDG_STATE_HOME:-"${HOME}/.local/state"}"
export XDG_RUNTIME_DIR="${XDG_RUNTIME_DIR:-"${HOME}/.local/run"}"

# Ensure these directories exist
mkdir -p "${XDG_CONFIG_HOME}" "${XDG_CACHE_HOME}" "${XDG_DATA_HOME}" "${XDG_STATE_HOME}"

# Ensure XDG_RUNTIME_DIR has the correct permissions
mkdir -p "${XDG_RUNTIME_DIR}" && chmod 0700 "${XDG_RUNTIME_DIR}" 

# --- Zsh Configuration Setup ---
export ZDOTDIR="${XDG_CONFIG_HOME}/zsh"

# Ensure Zsh directory exists
mkdir -p "${ZDOTDIR}"

# --- PATH Configuration ---
# Add directories to PATH safely
export PATH="/usr/local/bin:${PATH}:${HOME}/bin"

# Remove duplicate entries in PATH
typeset -U PATH path

# --- Application Defaults ---
export PAGER="less"
export EDITOR="vim"
export VISUAL="vim"  

# --- Less Configuration ---
export LESS="-R -i -g -c -W -M -J"
export LESSHISTFILE="${XDG_CACHE_HOME}/less/history"
mkdir -p "$(dirname "${LESSHISTFILE}")"

# --- Locale Settings ---
# Uncomment if needed:
export LANG=en_AU.UTF-8
export LC_COLLATE=C

# --- Python Configuration ---
export PYTHONSTARTUP="${XDG_CONFIG_HOME}/python/pythonrc"
export PYTHONHISTORY="${XDG_CONFIG_HOME}/python/history"

# Ensure python directory exists
mkdir -p "${XDG_CONFIG_HOME}/python"

# --- Vim Configuration ---
export MYVIMRC="${XDG_CONFIG_HOME}/vim/vimrc"
export VIMINIT="source ${MYVIMRC}"

# Ensure Vim directory exists
mkdir -p "${XDG_CONFIG_HOME}/vim"

# --- macOS Specific Settings ---
# Prevent macOS from creating .DS_Store files on network volumes
export COPY_EXTENDED_ATTRIBUTES_DISABLE=true
export COPYFILE_DISABLE=true

# --- Dotfiles Management ---
if [[ -d "${HOME}/dotfiles" ]]; then
    export DOTFILES="${HOME}/dotfiles"
elif [[ -d "${HOME}/.dotfiles" ]]; then
    export DOTFILES="${HOME}/.dotfiles"
fi
