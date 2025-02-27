# Oh My Zsh configuration
export ZSH="${XDG_CONFIG_HOME}/oh-my-zsh"
ZSH_THEME="robbyrussell"

# History options
setopt EXTENDED_HISTORY          # Write the history file in the ':start:elapsed;command' format
setopt HIST_IGNORE_DUPS         # Do not record an event that was just recorded again
setopt HIST_IGNORE_ALL_DUPS     # Delete an old recorded event if a new event is a duplicate

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
unalias run-help
autoload run-help

# Plugin configuration
plugins=(git macos tmux you-should-use)

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

# Lazy-load aliases
alias nvm="load_nvm nvm"
alias node="load_nvm node"
alias npm="load_nvm npm"

# Zoxide setup
eval "$(zoxide init zsh --cmd cd)"
