# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set custom Paths
export GIT_CONFIG="$HOME/.config/git/config"
export ZSHDDIR="$ZDOTDIR/sessions"

# Increase history size
HISTSIZE=10000
SAVEHIST=20000
HISTFILE="$ZDOTDIR/.zsh_history"

# Set the location for .zcompdump files
export ZSH_COMPDUMP="$ZDOTDIR/.zcompdump-${ZSH_VERSION}"
zstyle ':zsh-session-manager:*' dir "$ZSHDDIR"

# Set name of the theme to load
ZSH_THEME="robbyrussell"

# Which plugins would you like to load?
plugins=(git macos tmux you-should-use)

# User configuration

# you-should-use configuration
export YSU_MODE=ALL
export YSU_HARDCORE=1
export YSU_MESSAGE_POSITION="after"

# Load Oh My Zsh
source $ZSH/oh-my-zsh.sh

# Load some quality of life functions.
source $ZDOTDIR/functions.zsh
source $ZDOTDIR/aliases.zsh

# Set up fzf key bindings and fuzzy completion
# Set up fzf key bindings and fuzzy completion
source <(fzf --zsh)
#[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Load additional plugins
source $HOMEBREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source $HOMEBREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# Performance optimizations
zstyle ':completion:*' accept-exact '*(N)'
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path $ZSH_CACHE_DIR

# Additional customizations can be added here
