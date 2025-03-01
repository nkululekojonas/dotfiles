# Oh My Zsh configuration
export ZSH="${XDG_CONFIG_HOME}/oh-my-zsh"
ZSH_THEME="robbyrussell"

# Globing and Expansion
setopt EXTENDED_GLOB         

# History & Navigation
setopt AUTO_CD
setopt EXTENDED_HISTORY      
setopt HIST_IGNORE_DUPS     
setopt HIST_IGNORE_ALL_DUPS  
setopt INC_APPEND_HISTORY

# More History configuration
export HISTSIZE=10000
export SAVEHIST=20000
export HISTFILE="${ZDOTDIR}/.zsh_history"

# Completion configuration
zstyle ':completion:*' accept-exact '*(N)'
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path "${XDG_CACHE_HOME}/zsh"
zstyle ':zsh-session-manager:*' dir "${ZDOTDIR}"

# Set zcompdump location
export ZSH_COMPDUMP="${XDG_CACHE_HOME}/zsh/zcompdump-${ZSH_VERSION}"

# Ensure proper run-help configuration
# Remove the default 'run-help' alias if it exists
unalias run-help 2> /dev/null

# Load Zsh's enhanced run-help system
autoload -Uz run-help
autoload -Uz run-help-git  # Enable git-specific help (optional)

# Plugin configuration
plugins=(git macos tmux)

# You-should-use settings
export YSU_MODE="ALL"
export YSU_HARDCORE=1
export YSU_MESSAGE_POSITION="after"

# Load Oh My Zsh
if [[ -f "${ZSH}/oh-my-zsh.sh" ]]; then
    source "${ZSH}/oh-my-zsh.sh"
else
    echo "Warning: Oh My Zsh not found in ${ZSH}" >&2
fi

# Load custom configurations
[[ -f "${ZDOTDIR}/functions.zsh" ]] && source "${ZDOTDIR}/functions.zsh"
[[ -f "${ZDOTDIR}/aliases.zsh" ]] && source "${ZDOTDIR}/aliases.zsh"

# FZF configuration using Homebrew paths
if command -v fzf >/dev/null 2>&1; then
    FZF_PREFIX="$(brew --prefix)/opt/fzf/shell"
    [[ -f "${FZF_PREFIX}/key-bindings.zsh" ]] && source "${FZF_PREFIX}/key-bindings.zsh"
    [[ -f "${FZF_PREFIX}/completion.zsh" ]] && source "${FZF_PREFIX}/completion.zsh"
fi

# Ensure HOMEBREW_PREFIX is set (fallback to brew --prefix)
HOMEBREW_PREFIX="${HOMEBREW_PREFIX:-$(brew --prefix)}"

# Additional plugins loaded only in interactive terminals
if [[ -o interactive ]]; then
    [[ -f "${HOMEBREW_PREFIX}/share/zsh-autosuggestions/zsh-autosuggestions.zsh" ]] && source "${HOMEBREW_PREFIX}/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
    [[ -f "${HOMEBREW_PREFIX}/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]] && source "${HOMEBREW_PREFIX}/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
    [[ -f "$(brew --prefix)/share/zsh-history-substring-search/zsh-history-substring-search.zsh" ]] && source "$(brew --prefix)/share/zsh-history-substring-search/zsh-history-substring-search.zsh"
fi

# Git configuration
unset GIT_CONFIG
autoload -Uz compinit && compinit
zstyle ':completion:*:*:git:*' script "${ZDOTDIR}/git-completion.zsh"
fpath=("${ZDOTDIR}" "${fpath[@]}")

# --- Node.js Configuration ---
export NVM_DIR="${XDG_CONFIG_HOME}/nvm"
export NPM_CONFIG_USERCONFIG="${XDG_CONFIG_HOME}/npm/npmrc"

# NVM Lazy-Loading 
load_nvm() {
    unset -f nvm node npm  # Clean removal of loader functions
    if [[ -s "${NVM_DIR}/nvm.sh" ]]; then
        source "${NVM_DIR}/nvm.sh"
        [[ -s "${NVM_DIR}/bash_completion" ]] && source "${NVM_DIR}/bash_completion"
    else
        echo "NVM not installed in ${NVM_DIR}" >&2
        return 1
    fi
    [[ $# -gt 0 ]] && "$@"
}

# Detect which `ls` flavor is in use
if ls --color > /dev/null 2>&1; then # GNU `ls`
    colorflag="--color"
    export LS_COLORS='no=00:fi=00:di=01;31:ln=01;36:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arj=01;31:*.taz=01;31:*.lzh=01;31:*.zip=01;31:*.z=01;31:*.Z=01;31:*.gz=01;31:*.bz2=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.jpg=01;35:*.jpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:'
else # macOS `ls`
    colorflag="-G"
    export LSCOLORS='BxBxhxDxfxhxhxhxhxcxcx'
fi

# Zoxide setup
eval "$(zoxide init zsh --cmd cd)"
