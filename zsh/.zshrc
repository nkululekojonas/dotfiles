# Zsh Interactive Shell Configuration 

# --- Ensure Required Directories Exist  ---
mkdir -p \
  "${XDG_CONFIG_HOME:=${HOME}/.config}" \
  "${XDG_CACHE_HOME:=${HOME}/.cache}" \
  "${XDG_DATA_HOME:=${HOME}/.local/share}" \
  "${XDG_STATE_HOME:=${HOME}/.local/state}" \
  "${XDG_RUNTIME_DIR:=${HOME}/.local/run}" \
  "${XDG_CONFIG_HOME}/zsh" \
  "${XDG_CONFIG_HOME}/python" \
  "${XDG_CONFIG_HOME}/vim" \
  "$(dirname "${XDG_CACHE_HOME}/less/history")" \
  "${XDG_CACHE_HOME}/zsh" 

# Ensure XDG_RUNTIME_DIR has the correct permissions (0700)
if [[ -d "${XDG_RUNTIME_DIR}" ]]; then
  chmod 0700 "${XDG_RUNTIME_DIR}"
fi

# --- PATH Uniqueness ---
typeset -U PATH path # Ensure the PATH variable does not contain duplicate directories.

# --- Oh My Zsh Configuration ---

# Define Zsh completion cache/dump file path using XDG standard
export ZSH_COMPDUMP="${XDG_CACHE_HOME:-$HOME/.cache}/zsh/zcompdump-${ZSH_VERSION}"

# Set Oh My Zsh installation directory (using XDG standard)
export ZSH="${XDG_CONFIG_HOME:-$HOME/.config}/oh-my-zsh" 

# Set Oh My Zsh Theme
ZSH_THEME="robbyrussell"

# --- Oh My Zsh Plugin Configuration ---
plugins=(
    tmux                     # tmux integration and shortcuts
    macos
    zsh-autosuggestions      # Fish-like autosuggestions
    history-substring-search # Advanced history search based on current input
    fast-syntax-highlighting # Faster syntax highlighting alternative
)

# --- Load Oh My Zsh ---
if [[ -f "${ZSH}/oh-my-zsh.sh" ]]; then
  source "${ZSH}/oh-my-zsh.sh"
else
  echo "Warning: Oh My Zsh not found at ${ZSH}" >&2
fi

# --- Zsh Options (`setopt`) ---
# Configure various shell behaviors for interactive use.

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

# History Configuration 
export HISTSIZE=10000      # Max history lines kept in memory per active session
export SAVEHIST=20000      # Max history lines saved in the history file

# Use XDG path for history file (directory created at the top)
export HISTFILE="${XDG_CACHE_HOME:-$HOME/.cache}/zsh/history"

# --- Completion Styling (`zstyle`) ---
# Configure the behavior and appearance of the Zsh completion system.
zstyle ':completion:*' accept-exact '*(N)' # Accept exact matches even if other completions exist
zstyle ':completion:*' use-cache on        # Enable caching for completion results

# Store cache per XDG spec (directory created at the top)
zstyle ':completion:*' cache-path "${XDG_CACHE_HOME:-$HOME/.cache}/zsh"

# Remove the default 'run-help' alias if it exists to avoid conflict
unalias run-help 2> /dev/null

# Load Zsh's enhanced run-help system for better help display
autoload -Uz run-help

# Load Git-specific help commands (optional, requires Git)
autoload -Uz run-help-git

# Git configuration (ensure Zsh doesn't interfere with Git's own config finding)
unset GIT_CONFIG

# --- Custom Keybindings ---

# History search (up/down arrow searches history based on current line prefix)
autoload -U up-line-or-beginning-search
autoload -U down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search

# Note: Key sequences like ^[[A might vary between terminals. Use `showkey -a` or `cat -v` to verify.
bindkey "^[[A" up-line-or-beginning-search  # Up arrow
bindkey "^[[B" down-line-or-beginning-search # Down arrow

# Edit command line in $EDITOR (^X^E)
autoload -z edit-command-line
zle -N edit-command-line
bindkey "^X^E" edit-command-line

# --- LS Colors ---
if ls --color > /dev/null 2>&1; then 
    colorflag="--color=auto"    # Modern macOS/BSD '/bin/ls' supports --colorflag
else 
    colorflag="-G"              # Assume older macOS/BSD ls or non-standard GNU ls
fi

# --- Source Personal Scripts ---
[[ -f "${ZDOTDIR}/functions.zsh" ]] && source "${ZDOTDIR}/functions.zsh"
[[ -f "${ZDOTDIR}/.aliasrc" ]] && source "${ZDOTDIR}/.aliasrc"

# Set a DOTFILES variable if a standard location exists.
if [[ -d "${HOME}/dotfiles" ]]; then
    export DOTFILES="${HOME}/dotfiles"
elif [[ -d "${HOME}/.dotfiles" ]]; then
    export DOTFILES="${HOME}/.dotfiles"
fi

# --- Tool Configurations ---

# FZF (Fuzzy Finder)
# Find FZF shell integration files
local fzf_prefix
if [[ -n "$HOMEBREW_PREFIX" ]]; then
    fzf_prefix="$HOMEBREW_PREFIX"
elif (( $+commands[brew] )); then # More efficient Zsh way to check for a command
    fzf_prefix="$(brew --prefix)"
fi

if [[ -d "${fzf_prefix}/opt/fzf/shell" ]]; then
    local fzf_base_path="${fzf_prefix}/opt/fzf/shell"
    [[ -f "${fzf_base_path}/key-bindings.zsh" ]] && source "${fzf_base_path}/key-bindings.zsh"
    [[ -f "${fzf_base_path}/completion.zsh" ]] && source "${fzf_base_path}/completion.zsh"
else
    echo "Warning: FZF shell integration not found." >&2
fi
unset fzf_prefix fzf_base_path # Clean up

# Zoxide (Smart cd command)
if command -v zoxide >/dev/null 2>&1; then
  eval "$(zoxide init zsh --cmd cd)"
fi
