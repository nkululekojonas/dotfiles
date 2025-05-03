# ~/.zshenv
#------------------------------------------------------------------------------#
# Zsh Environment Configuration (Loaded for ALL shell types)                   #
#------------------------------------------------------------------------------#
#
# --- XDG Base Directory Specification Compliance ---
# Define standard locations for user-specific config, data, cache, etc.
# These provide defaults if the corresponding variables are not already set.
export XDG_CACHE_HOME="${XDG_CACHE_HOME:-"${HOME}/.cache"}"
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-"${HOME}/.config"}"
export XDG_DATA_HOME="${XDG_DATA_HOME:-"${HOME}/.local/share"}"
export XDG_STATE_HOME="${XDG_STATE_HOME:-"${HOME}/.local/state"}"
export XDG_RUNTIME_DIR="${XDG_RUNTIME_DIR:-"${HOME}/.local/run"}"

# --- Zsh Configuration Setup ---
# Tell Zsh where to find its configuration files (using XDG standard)
export ZDOTDIR="${XDG_CONFIG_HOME}/zsh"

# --- PATH Configuration ---
# Set the initial command search path.
export PATH="/usr/local/bin:${PATH}:${HOME}/bin"

# --- Application Defaults ---
# Set default applications used by various command-line tools.
export PAGER="less"    
export EDITOR="vim"    
export VISUAL="vim"    

# --- Less Configuration ---
# Configure the 'less' pager.
# -R: Output raw control characters (enables color)
# -i: Case-insensitive search unless uppercase letters are used
# -g: Highlight only the current match in searches
# -c: Clear screen before display instead of scrolling
# -W: Highlight first line after EOF
# -M: Display more detailed prompt (filename, line number, percentage)
# -J: Display status column on left with marks for search results
export LESS="-R -i -g -c -W -M -J"

# Set the location for less's history file (using XDG standard)
export LESSHISTFILE="${XDG_CACHE_HOME}/less/history"

# --- Locale Settings ---
# Set language and localization preferences.
export LANG=en_AU.UTF-8 # Primary language and character encoding
export LC_COLLATE=C     # Use standard C/POSIX collation order for sorting (often faster)

# --- Python Configuration ---
# Configure Python's interactive startup and history files (using XDG standard).
export PYTHONSTARTUP="${XDG_CONFIG_HOME}/python/pythonrc"
export PYTHONHISTORY="${XDG_CONFIG_HOME}/python/history"

# --- Vim Configuration ---
# Tell Vim where to find its main configuration file (using XDG standard).
export MYVIMRC="${XDG_CONFIG_HOME}/vim/vimrc"

# Set VIMINIT to source the custom vimrc (alternative to ~/.vimrc).
export VIMINIT="source ${MYVIMRC}"

# --- macOS Specific Settings ---
# Prevent macOS from creating hidden .DS_Store metadata files on network volumes.
export COPY_EXTENDED_ATTRIBUTES_DISABLE=true
export COPYFILE_DISABLE=true

# --- End of .zshenv ---
