# .zshrc
# Zsh Interactive Shell Configuration 

# --- Ensure Required Directories Exist  ---
# Only create essential directories that don't exist (faster check)
mkdir -p "${XDG_CONFIG_HOME}/zsh" "${XDG_CACHE_HOME}/zsh"

# Optional: Only create DATA/STATE directories if you use tools that need them
# Uncomment these lines if needed (npm, pipx, cargo, poetry, etc.):
# mkdir -p "${XDG_DATA_HOME}" "${XDG_STATE_HOME}"

# --- PATH Configuration ---
# Set the initial command search path.
export PATH="${PATH}:${HOME}/bin"

# Ensure the PATH variable does not contain duplicate directories.
typeset -U PATH path 

# --- Oh My Zsh Configuration ---
# Set Oh My Zsh installation directory (using XDG standard)
export ZSH="${XDG_CONFIG_HOME}/oh-my-zsh" 

# Set Oh My Zsh Theme
ZSH_THEME="robbyrussell"

# Disable Oh My Zsh features we don't need for faster startup
DISABLE_AUTO_UPDATE=true
DISABLE_UPDATE_PROMPT=true
DISABLE_MAGIC_FUNCTIONS=true        # Disables URL quoting, etc.
DISABLE_UNTRACKED_FILES_DIRTY=true  # Faster git status in Oh My Zsh prompt
ZSH_DISABLE_COMPFIX=true            # Skip permission checks
DISABLE_AUTO_TITLE=true             # Don't auto-set terminal title
ZSH_COMPDUMP="${XDG_CACHE_HOME}/zsh/zcompdump-${ZSH_VERSION}"

# --- Oh My Zsh Plugin Configuration ---
plugins=( 
    git 
    brew        # Homebrew aliases and completion 
    colored-man-pages  # Colorized man pages
    zsh-autosuggestions 
    history-substring-search 
    fast-syntax-highlighting 
)

# --- Load Oh My Zsh ---
[[ -f "${ZSH}/oh-my-zsh.sh" ]] && source "${ZSH}/oh-my-zsh.sh"

# --- Zsh Options (`setopt`) ---
# Note: Oh-My-Zsh sets many options by default. Only adding/overriding specific ones here.

# General Usability
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
setopt HIST_VERIFY        # Show command from history before executing it upon expansion
setopt HIST_SAVE_NO_DUPS  # Don't save duplicate commands across the entire history file
setopt HIST_REDUCE_BLANKS # Remove superfluous blanks from history items before saving

# Completion Behavior
setopt COMPLETE_ALIASES   # Complete aliases like regular commands
setopt PATH_DIRS          # Perform path search even on command names containing slashes

# --- Completion Styling (`zstyle`) ---
# Configure the behavior and appearance of the Zsh completion system.
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*' accept-exact '*(N)' # Accept exact matches even if other completions exist
zstyle ':completion:*' menu select
zstyle ':completion:*' use-cache on        # Enable caching for completion results
zstyle ':completion:*' cache-path "${XDG_CACHE_HOME}/zsh/compcache"  # Store cache per XDG spec 

# Better completion for kill command
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'

# Remove the default 'run-help' alias if it exists to avoid conflict
unalias run-help 2>/dev/null

# Load Zsh's enhanced run-help system for better help display
autoload -Uz run-help run-help-git

# --- Source Shared Configurations ---
[[ -f "${XDG_CONFIG_HOME}/shell/.functions" ]] && source "${XDG_CONFIG_HOME}/shell/.functions"
[[ -f "${XDG_CONFIG_HOME}/shell/.aliases" ]] && source "${XDG_CONFIG_HOME}/shell/.aliases"

# --- Tool Configurations ---

# Use vim style navigation keys in menu completion
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char
bindkey -M menuselect 'j' vi-down-line-or-history

# FZF (Fuzzy Finder)
if [[ -d "/opt/homebrew/opt/fzf/shell" ]]; then
    source /opt/homebrew/opt/fzf/shell/key-bindings.zsh
    source /opt/homebrew/opt/fzf/shell/completion.zsh
fi

# Zoxide (Smart cd command) - cached for faster startup
[[ -f "${XDG_CONFIG_HOME}/zoxide/zoxide.zsh" ]] && source "${XDG_CONFIG_HOME}/zoxide/zoxide.zsh"
