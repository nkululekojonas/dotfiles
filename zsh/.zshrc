# Zsh Interactive Shell Configuration 

# --- Ensure Required Directories Exist  ---
# Only create if they don't exist (faster check)
[[ ! -d "${XDG_CONFIG_HOME:=${HOME}/.config}" ]] && mkdir -p "${XDG_CONFIG_HOME}"
[[ ! -d "${XDG_CACHE_HOME:=${HOME}/.cache}" ]] && mkdir -p "${XDG_CACHE_HOME}"
[[ ! -d "${XDG_DATA_HOME:=${HOME}/.local/share}" ]] && mkdir -p "${XDG_DATA_HOME}"
[[ ! -d "${XDG_STATE_HOME:=${HOME}/.local/state}" ]] && mkdir -p "${XDG_STATE_HOME}"
[[ ! -d "${XDG_RUNTIME_DIR:=${HOME}/.local/run}" ]] && mkdir -p "${XDG_RUNTIME_DIR}"
[[ ! -d "${XDG_CONFIG_HOME}/zsh" ]] && mkdir -p "${XDG_CONFIG_HOME}/zsh"
[[ ! -d "${XDG_CACHE_HOME}/zsh" ]] && mkdir -p "${XDG_CACHE_HOME}/zsh"

# Ensure XDG_RUNTIME_DIR has the correct permissions (0700)
[[ -d "${XDG_RUNTIME_DIR}" ]] && chmod 0700 "${XDG_RUNTIME_DIR}"

# --- PATH Configuration ---
# Ensure the PATH variable does not contain duplicate directories.
typeset -U PATH path 

# --- Oh My Zsh Configuration ---
# Set Oh My Zsh installation directory (using XDG standard)
export ZSH="${XDG_CONFIG_HOME:-$HOME/.config}/oh-my-zsh" 

# Set Oh My Zsh Theme
ZSH_THEME="robbyrussell"

# Disable Oh My Zsh features we don't need for faster startup
DISABLE_AUTO_UPDATE=true
DISABLE_UPDATE_PROMPT=true
DISABLE_MAGIC_FUNCTIONS=true  # Disables URL quoting, etc.

# --- Oh My Zsh Plugin Configuration ---
# Note: Loading plugins manually for faster startup
plugins=()

# --- Load Oh My Zsh ---
[[ -f "${ZSH}/oh-my-zsh.sh" ]] && source "${ZSH}/oh-my-zsh.sh"

# --- Zsh Options (`setopt`) ---
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
export HISTFILE="${XDG_CACHE_HOME:-$HOME/.cache}/zsh/history"       # Use XDG path for history file 

# --- Completion Styling (`zstyle`) ---
# Configure the behavior and appearance of the Zsh completion system.
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*' accept-exact '*(N)' # Accept exact matches even if other completions exist
zstyle ':completion:*' menu select
zstyle ':completion:*' use-cache on        # Enable caching for completion results
zstyle ':completion:*' cache-path "${XDG_CACHE_HOME:-$HOME/.cache}/zsh"     # Store cache per XDG spec 

# Better completion for kill command
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'

# Remove the default 'run-help' alias if it exists to avoid conflict
unalias run-help 2> /dev/null

# Load Zsh's enhanced run-help system for better help display
autoload -Uz run-help run-help-git

# Git configuration 
unset GIT_CONFIG

# --- Custom Keybindings ---
# History search (up/down arrow searches history based on current line prefix)
autoload -U up-line-or-beginning-search down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search

# Note: Key sequences like ^[[A might vary between terminals. Use `showkey -a` or `cat -v` to verify.
bindkey "^[[A" up-line-or-beginning-search  # Up arrow
bindkey "^[[B" down-line-or-beginning-search # Down arrow

# --- Load Plugins Manually (Faster) ---
# zsh-autosuggestions - Fish-like autosuggestions
[[ -f "${ZSH}/custom/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh" ]] && \
    source "${ZSH}/custom/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh"

# history-substring-search - Advanced history search based on current input
# Note: Bind after defining arrow key functions above
if [[ -f "${ZSH}/custom/plugins/history-substring-search/history-substring-search.zsh" ]]; then
    source "${ZSH}/custom/plugins/history-substring-search/history-substring-search.zsh"
    # Rebind to use history-substring-search with syntax highlighting
    bindkey "^[[A" history-substring-search-up
    bindkey "^[[B" history-substring-search-down
fi

# fast-syntax-highlighting - Faster syntax highlighting alternative (load LAST for proper highlighting)
[[ -f "${ZSH}/custom/plugins/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh" ]] && \
    source "${ZSH}/custom/plugins/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh"

# --- LS Colors ---
export CLICOLOR=1
export LSCOLORS=Gxfxcxdxbxegedabagacad

# For GNU ls (if installed via coreutils)
if ls --color >/dev/null 2>&1; then
    colorflag="--color=auto"
    export LS_COLORS='di=1;36:ln=35:so=32:pi=33:ex=31:bd=34;46:cd=34;43:su=30;41:sg=30;46:tw=30;42:ow=30;43'
else
    colorflag="-G"
fi

# --- Source Personal Scripts ---
# These files work across both Zsh and Bash
[[ -f "${ZDOTDIR}/.functionsrc" ]] && source "${ZDOTDIR}/.functionsrc"
[[ -f "${ZDOTDIR}/.aliasrc" ]] && source "${ZDOTDIR}/.aliasrc"

# --- Set DOTFILES Variable ---
# Set a DOTFILES variable if a standard location exists.
if [[ -d "${HOME}/dotfiles" ]]; then
    export DOTFILES="${HOME}/dotfiles"
elif [[ -d "${HOME}/.dotfiles" ]]; then
    export DOTFILES="${HOME}/.dotfiles"
fi

# --- Tool Configurations ---
# FZF (Fuzzy Finder)
# Find FZF shell integration files
if [[ -n "$HOMEBREW_PREFIX" ]]; then
    local fzf_base_path="${HOMEBREW_PREFIX}/opt/fzf/shell"
elif (( $+commands[brew] )); then
    local fzf_base_path="$(brew --prefix)/opt/fzf/shell"
fi

if [[ -n "$fzf_base_path" && -d "$fzf_base_path" ]]; then
    [[ -f "${fzf_base_path}/key-bindings.zsh" ]] && source "${fzf_base_path}/key-bindings.zsh"
    [[ -f "${fzf_base_path}/completion.zsh" ]] && source "${fzf_base_path}/completion.zsh"
fi
unset fzf_base_path # Clean up

# Zoxide (Smart cd command)
(( $+commands[zoxide] )) && eval "$(zoxide init zsh --cmd cd)"