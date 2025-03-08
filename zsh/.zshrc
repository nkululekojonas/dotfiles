# Compile zcompdump to speed up loading
autoload -Uz compinit
if [[ -n ${ZDOTDIR}/.zcompdump(#qN.mh+24) ]]; then
	compinit
else
	compinit -C
fi

# Oh My Zsh configuration
export ZSH="${XDG_CONFIG_HOME:-$HOME/.config}/oh-my-zsh"
ZSH_THEME="robbyrussell"

# Improve autocompletion experience
setopt AUTO_MENU

# Enhance globbing
setopt EXTENDED_GLOB
setopt GLOB_DOTS

# Improve history management
setopt HIST_VERIFY
setopt SHARE_HISTORY
setopt EXTENDED_HISTORY      
setopt HIST_IGNORE_DUPS     
setopt HIST_SAVE_NO_DUPS
setopt HIST_REDUCE_BLANKS 
setopt INC_APPEND_HISTORY
setopt HIST_IGNORE_ALL_DUPS  

# More History configuration
export HISTSIZE=10000
export SAVEHIST=20000
export HISTFILE="${XDG_CACHE_HOME:-$HOME/.cache}/zsh/history"
mkdir -p "$(dirname "${HISTFILE}")"

# Disable terminal beeps
setopt NO_BEEP

# Directory options
setopt AUTO_CD               # cd by typing directory name
setopt AUTO_PUSHD            # Push the old directory onto the stack on cd
setopt PUSHD_IGNORE_DUPS     # Don't push duplicate directories
setopt PUSHD_SILENT  

# Completion
setopt ALWAYS_TO_END         # Move cursor to end of completed word
setopt COMPLETE_IN_WORD      # Allow completion from within a word
setopt PATH_DIRS             # Perform path search even on command names with slashes
setopt AUTO_MENU             # Show completion menu on tab press
setopt COMPLETE_ALIASES      # Complete aliases

# Input/Output
setopt INTERACTIVE_COMMENTS  # Allow comments in interactive shells
setopt NO_FLOW_CONTROL       # Disable ^S/^Q flow control
setopt RM_STAR_WAIT          # Wait 10 seconds before accepting rm *

# Better job control
setopt AUTO_RESUME
setopt LONG_LIST_JOBS

# Completion configuration
zstyle ':completion:*' accept-exact '*(N)'
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path "${XDG_CACHE_HOME:-$HOME/.cache}/zsh"
zstyle ':zsh-session-manager:*' dir "${XDG_CACHE_HOME:-$HOME/.cache}/zsh"

# Set zcompdump location
export ZSH_COMPDUMP="${XDG_CACHE_HOME:-$HOME/.cache}/zsh/zcompdump-${ZSH_VERSION}"

# Ensure proper run-help configuration
# Remove the default 'run-help' alias if it exists
unalias run-help 2> /dev/null

# Load Zsh's enhanced run-help system
autoload -Uz run-help
autoload -Uz run-help-git  # Enable git-specific help (optional)

# Plugin configuration
plugins=(git macos tmux)

# Better history search
autoload -U up-line-or-beginning-search
autoload -U down-line-or-beginning-search

zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey "^[[A" up-line-or-beginning-search    # Up
bindkey "^[[B" down-line-or-beginning-search  # Down

# Load Oh My Zsh
[[ -f "${ZSH}/oh-my-zsh.sh" ]] && source "${ZSH}/oh-my-zsh.sh"

# Load custom configurations
[[ -f "${ZDOTDIR:-$HOME/.zsh}/functions.zsh" ]] && source "${ZDOTDIR:-$HOME/.zsh}/functions.zsh"
[[ -f "${ZDOTDIR:-$HOME/.zsh}/aliases.zsh" ]] && source "${ZDOTDIR:-$HOME/.zsh}/aliases.zsh"

# FZF configuration using Homebrew paths
if command -v fzf >/dev/null 2>&1 && command -v brew >/dev/null 2>&1; then
    FZF_PREFIX="$(brew --prefix)/opt/fzf/shell"
    [[ -f "${FZF_PREFIX}/key-bindings.zsh" ]] && source "${FZF_PREFIX}/key-bindings.zsh"
    [[ -f "${FZF_PREFIX}/completion.zsh" ]] && source "${FZF_PREFIX}/completion.zsh"
fi

# Ensure HOMEBREW_PREFIX is set (fallback to brew --prefix)
if command -v brew >/dev/null 2>&1; then
    HOMEBREW_PREFIX="${HOMEBREW_PREFIX:-$(brew --prefix)}"
fi

# Additional plugins loaded only in interactive terminals
if [[ -o interactive ]]; then
    if [[ -n "${HOMEBREW_PREFIX}" ]]; then
        [[ -f "${HOMEBREW_PREFIX}/share/zsh-autosuggestions/zsh-autosuggestions.zsh" ]] && source "${HOMEBREW_PREFIX}/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
        [[ -f "${HOMEBREW_PREFIX}/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]] && source "${HOMEBREW_PREFIX}/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
        [[ -f "${HOMEBREW_PREFIX}/share/zsh-history-substring-search/zsh-history-substring-search.zsh" ]] && source "${HOMEBREW_PREFIX}/share/zsh-history-substring-search/zsh-history-substring-search.zsh"
    fi
fi


# Git configuration
unset GIT_CONFIG
[[ -f "${ZDOTDIR:-$HOME/.zsh}/git-completion.zsh" ]] && zstyle ':completion:*:*:git:*' script "${ZDOTDIR:-$HOME/.zsh}/git-completion.zsh"
fpath=("${ZDOTDIR:-$HOME/.zsh}" "${fpath[@]}")

# --- Node.js Configuration ---
mkdir -p "${XDG_CONFIG_HOME:-$HOME/.config}/nvm"
mkdir -p "${XDG_CONFIG_HOME:-$HOME/.config}/npm"

export NVM_DIR="$HOME/.config/nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# Detect which `ls` flavor is in use
if ls --color > /dev/null 2>&1; then # GNU `ls`
    colorflag="--color"
    export LS_COLORS='no=00:fi=00:di=01;31:ln=01;36:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arj=01;31:*.taz=01;31:*.lzh=01;31:*.zip=01;31:*.z=01;31:*.Z=01;31:*.gz=01;31:*.bz2=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.jpg=01;35:*.jpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:'
else # macOS `ls`
    colorflag="-G"
    export LSCOLORS='BxBxhxDxfxhxhxhxhxcxcx'
fi

# Zoxide setup
command -v zoxide >/dev/null 2>&1 && eval "$(zoxide init zsh --cmd cd)"
