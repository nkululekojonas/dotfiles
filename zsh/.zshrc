# --- Zsh Completion Cache Setup ---
# Define Zsh completion cache/dump file path using XDG standard
export ZSH_COMPDUMP="${XDG_CACHE_HOME:-$HOME/.cache}/zsh/zcompdump-${ZSH_VERSION}"

# Ensure the cache directory exists
mkdir -p "$(dirname ${ZSH_COMPDUMP})"

# Initialize the completion system
# Use compinit with cache file, only check insecurity (-i) if needed
autoload -Uz compinit
if [[ -n ${ZSH_COMPDUMP}(#qN.mh+24) ]]; then
  compinit -i -d "$ZSH_COMPDUMP" # Load dump, check insecurity if needed
else
  compinit -C -i -d "$ZSH_COMPDUMP" # Create dump with insecurity check
fi

# --- Oh My Zsh Configuration ---
# Set Oh My Zsh installation directory (using XDG standard)
export ZSH="${XDG_CONFIG_HOME:-$HOME/.config}/oh-my-zsh"

# Set Oh My Zsh Theme
ZSH_THEME="robbyrussell" # Or your preferred theme

# --- Zsh Options (`setopt`) ---
# General Usability
setopt AUTO_MENU           # Show completion menu on second tab press
setopt COMPLETE_IN_WORD    # Allow completion from within a word
setopt ALWAYS_TO_END       # Move cursor to end of completed word
setopt GLOB_DOTS           # Include dotfiles in globbing results
setopt EXTENDED_GLOB       # Use extended globbing patterns
setopt NO_BEEP             # Disable terminal bells
setopt NO_FLOW_CONTROL     # Disable ^S/^Q flow control
setopt INTERACTIVE_COMMENTS # Allow comments in interactive shell
setopt RM_STAR_WAIT        # Add 10 sec confirmation for 'rm *'

# Directory Navigation
setopt AUTO_CD             # cd by typing directory name if it's not a command
setopt AUTO_PUSHD          # Push the old directory onto the stack on cd
setopt PUSHD_IGNORE_DUPS   # Don't push duplicate directories onto the stack
setopt PUSHD_SILENT        # Don't print the directory stack after pushd/popd

# History
setopt EXTENDED_HISTORY    # Record timestamp and duration for each command
setopt HIST_VERIFY         # Show command from history before executing
setopt HIST_IGNORE_ALL_DUPS # If new command is same as previous, don't save
setopt HIST_SAVE_NO_DUPS   # Don't save duplicate commands in the history file
setopt HIST_REDUCE_BLANKS  # Remove superfluous blanks from history items
setopt INC_APPEND_HISTORY  # Save history entries as soon as they are entered
setopt SHARE_HISTORY       # Share history between all active shells (requires INC_APPEND_HISTORY)

# Job Control
setopt AUTO_RESUME         # Attempt to resume jobs automatically
setopt LONG_LIST_JOBS      # List jobs in long format by default
setopt NOTIFY              # Report status of background jobs immediately

# Completion Behavior
setopt COMPLETE_ALIASES    # Complete aliases
setopt PATH_DIRS           # Perform path search even on command names with slashes

# --- History Configuration ---
export HISTSIZE=10000      # Max history lines kept in memory per session
export SAVEHIST=20000      # Max history lines saved in the history file
export HISTFILE="${XDG_CACHE_HOME:-$HOME/.cache}/zsh/history"

# Ensure history directory exists (compdump mkdir might have already done this)
mkdir -p "$(dirname "${HISTFILE}")"

# --- Completion Styling (`zstyle`) ---
zstyle ':completion:*' accept-exact '*(N)' # Accept exact matches even if ambiguous
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path "${XDG_CACHE_HOME:-$HOME/.cache}/zsh" # Store cache per XDG spec

# --- Enhanced Help Commands ---
# Remove the default 'run-help' alias if it exists to avoid conflict
unalias run-help 2> /dev/null

# Load Zsh's enhanced run-help system
autoload -Uz run-help
autoload -Uz run-help-git  # Enable git-specific help (optional)

# Git configuration
unset GIT_CONFIG

# --- Oh My Zsh Plugin Configuration ---
# List plugins for Oh My Zsh to load.
plugins=(
    git
    macos
    tmux
    zsh-syntax-highlighting  
    zsh-autosuggestions      
    history-substring-search 
)

# --- Custom Keybindings ---
# History search (up/down arrow searches history based on current line)
autoload -U up-line-or-beginning-search
autoload -U down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey "^[[A" up-line-or-beginning-search   # Up arrow (check your terminal's sequence if needed)
bindkey "^[[B" down-line-or-beginning-search # Down arrow (check your terminal's sequence if needed)

# Edit command line in $EDITOR (^X^E)
autoload -z edit-command-line
zle -N edit-command-line
bindkey "^X^E" edit-command-line

# --- Load Oh My Zsh ---
# Source Oh My Zsh script if it exists
[[ -f "${ZSH}/oh-my-zsh.sh" ]] && source "${ZSH}/oh-my-zsh.sh"

# --- Load Custom Zsh Configurations ---
# Source personal functions and aliases using ZDOTDIR path
[[ -f "${ZDOTDIR}/functions.zsh" ]] && source "${ZDOTDIR}/functions.zsh"
[[ -f "${ZDOTDIR}/aliases.zsh" ]] && source "${ZDOTDIR}/aliases.zsh"

# --- Tool Configurations ---

# FZF (Find fuzzy) configuration using Homebrew paths
if command -v fzf >/dev/null 2>&1 && command -v brew >/dev/null 2>&1; then
    FZF_PREFIX="$(brew --prefix)/opt/fzf/shell"
    [[ -f "${FZF_PREFIX}/key-bindings.zsh" ]] && source "${FZF_PREFIX}/key-bindings.zsh"
    [[ -f "${FZF_PREFIX}/completion.zsh" ]] && source "${FZF_PREFIX}/completion.zsh"
fi

# NVM (Node Version Manager) configuration using XDG paths
export NVM_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/nvm"

# Ensure NVM directory exists
mkdir -p "$NVM_DIR"
# Load NVM script if it exists
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
# Load NVM bash_completion script if it exists
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
# Ensure NPM config directory exists (NVM might not create it)
mkdir -p "${XDG_CONFIG_HOME:-$HOME/.config}/npm"

# Zoxide (Smart cd) setup
command -v zoxide >/dev/null 2>&1 && eval "$(zoxide init zsh --cmd cd)"

# --- LS Colors ---
# Detect which `ls` flavor is in use (GNU vs macOS/BSD)
if ls --color > /dev/null 2>&1; then # GNU `ls`
    colorflag="--color=auto" # Use --color=auto for GNU ls
    # export LS_COLORS='...' # Optional: Set custom LS_COLORS if desired
else # macOS `ls`
    colorflag="-G" # Use -G for macOS ls
    export LSCOLORS='BxBxhxDxfxhxhxhxhxcxcx' # Default macOS LSCOLORS
fi

# --- End of .zshrc ---
