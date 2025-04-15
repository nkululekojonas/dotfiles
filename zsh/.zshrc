# ~/.config/zsh/.zshrc

# --- Oh My Zsh Configuration ---
# Set Oh My Zsh installation directory (using XDG standard)
export ZSH="${XDG_CONFIG_HOME:-$HOME/.config}/oh-my-zsh"

# Set Oh My Zsh Theme
# robbyrussell is simple and fast. Other themes might impact performance.
ZSH_THEME="robbyrussell"

# --- Oh My Zsh Plugin Configuration ---
# List plugins for Oh My Zsh to load. Keep this list lean for faster startup.
# Examples: git, brew, docker, python, node, etc.
plugins=(
    tmux                     # tmux integration and shortcuts
    zsh-autosuggestions      # Fish-like autosuggestions
    history-substring-search # Advanced history search based on current input
    fast-syntax-highlighting # Faster syntax highlighting alternative
)
# Note: Ensure these plugins are compatible with OMZ or installed correctly.

# --- Load Oh My Zsh ---
# Source Oh My Zsh script. This loads the theme, plugins, and core OMZ functions.
# This is often a significant part of the startup time.
# Should be sourced *BEFORE* compinit and customisations that might depend on it.
if [[ -f "${ZSH}/oh-my-zsh.sh" ]]; then
  source "${ZSH}/oh-my-zsh.sh"
else
  echo "Warning: Oh My Zsh not found at ${ZSH}" >&2
fi
# --- End of Oh My Zsh Loading ---


# --- Zsh Completion Cache Setup ---
# Define Zsh completion cache/dump file path using XDG standard
# Run this *AFTER* Oh My Zsh and other fpath modifications so it picks up all completions.
export ZSH_COMPDUMP="${XDG_CACHE_HOME:-$HOME/.cache}/zsh/zcompdump-${ZSH_VERSION}"

# Ensure the cache directory exists
mkdir -p "$(dirname "${ZSH_COMPDUMP}")"

# Initialize the completion system (`compinit`)
# Autoload the compinit function if not already loaded
autoload -Uz compinit

# Check if the dump file exists and is older than 24 hours. Rebuild if needed.
# Using the cache (`-C`) is faster but might result in stale completions if used unconditionally.
# The `-i` flag makes compinit check for insecure files/dirs (recommended).
if [[ -n ${ZSH_COMPDUMP}(#qN.mh+24) ]]; then
  # Dump file exists but is older than 24 hours, rebuild it with insecurity checks
  compinit -i -d "$ZSH_COMPDUMP"
else
  # Dump file is recent or doesn't exist; use cache if possible, create if needed, check insecurity
  compinit -C -i -d "$ZSH_COMPDUMP"
fi
# --- End of Completion Setup ---


# --- Zsh Options (`setopt`) ---
# Options enhance shell usability and behavior. Setting them is very fast.

# General Usability
setopt AUTO_MENU          # Show completion menu on second tab press
setopt COMPLETE_IN_WORD   # Allow completion from within a word
setopt ALWAYS_TO_END      # Move cursor to end of completed word
setopt GLOB_DOTS          # Include dotfiles (starting with .) in globbing results
setopt EXTENDED_GLOB      # Use extended globbing patterns (^, ~, #, etc.)
setopt NO_BEEP            # Disable terminal bells for errors/completion
setopt NO_FLOW_CONTROL    # Disable ^S/^Q flow control (can interfere with some terminals)
setopt INTERACTIVE_COMMENTS # Allow comments (# ...) in interactive shell sessions
setopt RM_STAR_WAIT       # Add a 10-second confirmation delay for 'rm *' or 'rm path/*'

# Directory Navigation
setopt AUTO_CD            # Automatically cd by typing directory name if it's not a command
setopt AUTO_PUSHD         # Push the old directory onto the directory stack on cd
setopt PUSHD_IGNORE_DUPS  # Don't push duplicate directories onto the stack
setopt PUSHD_SILENT       # Don't print the directory stack after pushd/popd commands

# History
setopt EXTENDED_HISTORY   # Record timestamp and duration for each command in history
setopt HIST_VERIFY        # Show command from history before executing it upon expansion
setopt HIST_IGNORE_ALL_DUPS # If a new command is the same as the previous one, don't save it
setopt HIST_SAVE_NO_DUPS  # Don't save duplicate commands across the entire history file
setopt HIST_REDUCE_BLANKS # Remove superfluous blanks from history items before saving
setopt INC_APPEND_HISTORY # Save history entries incrementally as soon as they are entered
setopt SHARE_HISTORY      # Share history between all active shells (requires INC_APPEND_HISTORY)

# Job Control
setopt AUTO_RESUME        # Attempt to resume jobs automatically if unique identifier is typed
setopt LONG_LIST_JOBS     # List jobs in long format by default when 'jobs' is run
setopt NOTIFY             # Report status of background jobs immediately upon completion

# Completion Behavior
setopt COMPLETE_ALIASES   # Complete aliases like regular commands
setopt PATH_DIRS          # Perform path search even on command names containing slashes

# --- History Configuration ---
export HISTSIZE=10000      # Max history lines kept in memory per active session
export SAVEHIST=20000      # Max history lines saved in the history file (~/.cache/zsh/history)
export HISTFILE="${XDG_CACHE_HOME:-$HOME/.cache}/zsh/history" # Use XDG path for history file

# Ensure history directory exists (compdump mkdir might have already done this)
mkdir -p "$(dirname "${HISTFILE}")"

# --- Completion Styling (`zstyle`) ---
# Configure the behavior and appearance of the Zsh completion system.
zstyle ':completion:*' accept-exact '*(N)' # Accept exact matches even if other completions exist
zstyle ':completion:*' use-cache on        # Enable caching for completion results
zstyle ':completion:*' cache-path "${XDG_CACHE_HOME:-$HOME/.cache}/zsh" # Store cache per XDG spec

# --- Enhanced Help Commands ---
# Remove the default 'run-help' alias if it exists to avoid conflict
unalias run-help 2> /dev/null

# Load Zsh's enhanced run-help system for better help display
autoload -Uz run-help
# Load Git-specific help commands (optional, requires Git)
autoload -Uz run-help-git

# Git configuration (if needed)
# unset GIT_CONFIG # Uncomment if you need to explicitly clear Git config lookup path

# --- Custom Keybindings ---
# Setup custom keybindings using Zsh Line Editor (zle).

# History search (up/down arrow searches history based on current line prefix)
autoload -U up-line-or-beginning-search
autoload -U down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey "^[[A" up-line-or-beginning-search  # Up arrow (Verify sequence with 'showkey -a' or similar if needed)
bindkey "^[[B" down-line-or-beginning-search # Down arrow (Verify sequence if needed)

# Edit command line in $EDITOR (^X^E)
autoload -z edit-command-line
zle -N edit-command-line
bindkey "^X^E" edit-command-line

# --- Load Custom Zsh Configurations ---
# Source personal functions and aliases stored in separate files within ZDOTDIR.
# Good practice to source these after OMZ and compinit are set up.
[[ -f "${ZDOTDIR}/functions.zsh" ]] && source "${ZDOTDIR}/functions.zsh"
[[ -f "${ZDOTDIR}/aliases.zsh" ]] && source "${ZDOTDIR}/aliases.zsh"

# --- Tool Configurations ---

# FZF (Find fuzzy) configuration using optimized path lookup
# Try using HOMEBREW_PREFIX set in .zprofile first to avoid slower `brew --prefix` call.
local fzf_base_path
if [[ -n "$HOMEBREW_PREFIX" && -d "$HOMEBREW_PREFIX/opt/fzf/shell" ]]; then
    # Use prefix found by brew shellenv in .zprofile if available
    fzf_base_path="$HOMEBREW_PREFIX/opt/fzf/shell"
elif command -v brew >/dev/null 2>&1; then
    # Fallback: If HOMEBREW_PREFIX wasn't useful, try running brew --prefix now
    local brew_prefix_fzf="$(brew --prefix)"
    if [[ -n "$brew_prefix_fzf" && -d "$brew_prefix_fzf/opt/fzf/shell" ]]; then
        fzf_base_path="$brew_prefix_fzf/opt/fzf/shell"
    fi
    unset brew_prefix_fzf # Clean up temporary variable
fi

# If a valid FZF path was found, source its scripts
if [[ -n "$fzf_base_path" ]]; then
    [[ -f "${fzf_base_path}/key-bindings.zsh" ]] && source "${fzf_base_path}/key-bindings.zsh"
    [[ -f "${fzf_base_path}/completion.zsh" ]] && source "${fzf_base_path}/completion.zsh" # Adds FZF completions
else
    # Optional: Warn if FZF setup failed
    # echo "Warning: FZF shell integration not found or brew prefix unavailable." >&2
    : # No-op, just ensures the if block is valid even if empty
fi
unset fzf_base_path # Clean up temporary variable


# NVM (Node Version Manager) configuration using XDG paths (Lazy Load)
# This avoids running the slow nvm initialization on every shell startup.
export NVM_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/nvm"

# Ensure NVM directory and related npm config directory exist
mkdir -p "$NVM_DIR"
mkdir -p "${XDG_CONFIG_HOME:-$HOME/.config}/npm" # Npm might use this based on npmrc

# Define the lazy load function
lazy_load_nvm() {
  # Remove these placeholder functions first
  unset -f nvm node npm npx yarn pnpm corepack
  # Source NVM scripts only when needed
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # Load nvm
  [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" # Load nvm bash_completion (works in zsh)
  # Add other related tools here if needed after NVM loads
}

# Define placeholder functions that trigger the lazy load on first call
nvm() { lazy_load_nvm; nvm "$@"; }
node() { lazy_load_nvm; node "$@"; }
npm() { lazy_load_nvm; npm "$@"; }
npx() { lazy_load_nvm; npx "$@"; }
# Add placeholders for other Node-related tools you might use
yarn() { lazy_load_nvm; yarn "$@"; }
pnpm() { lazy_load_nvm; pnpm "$@"; }
corepack() { lazy_load_nvm; corepack "$@"; }


# Zoxide (Smart cd command) setup
# Ensure Zoxide command is available before trying to initialize it
if command -v zoxide >/dev/null 2>&1; then
  # Initialize Zoxide for Zsh, hooking into the 'cd' command
  eval "$(zoxide init zsh --cmd cd)"
fi

# --- LS Colors ---
# Detect which `ls` flavor is in use (GNU coreutils vs macOS/BSD) to set correct color flag.
if ls --color > /dev/null 2>&1; then # Check if GNU `ls` supports --color
    colorflag="--color=auto" # Use --color=auto for GNU ls
    # export LS_COLORS='...' # Optional: Set custom LS_COLORS for GNU ls if desired
else # Assume macOS/BSD `ls`
    colorflag="-G" # Use -G flag for enabling colors on macOS/BSD ls
    export LSCOLORS='BxBxhxDxfxhxhxhxhxcxcx' # Default macOS LSCOLORS (customize if needed)
fi
# Define aliases using this flag in your aliases.zsh file for consistency.
# Example: alias ls='ls ${colorflag}'
# Example: alias ll='ls -l ${colorflag}'

# --- End of .zshrc ---