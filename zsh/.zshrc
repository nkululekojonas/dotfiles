# Oh My Zsh configuration
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="robbyrussell"

# History options
setopt EXTENDED_HISTORY          # Write the history file in the ':start:elapsed;command' format
setopt HIST_IGNORE_DUPS         # Do not record an event that was just recorded again
setopt HIST_IGNORE_ALL_DUPS     # Delete an old recorded event if a new event is a duplicate

# Completion configuration
zstyle ':completion:*' accept-exact '*(N)'
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path "$XDG_CACHE_HOME/zsh"
zstyle ':zsh-session-manager:*' dir "$ZDOTDIR"

# Set zcompdump location
export ZSH_COMPDUMP="$XDG_CACHE_HOME/zsh/zcompdump-${ZSH_VERSION}"

# Plugin configuration
plugins=(git tmux you-should-use)

# You-should-use settings
export YSU_MODE=ALL
export YSU_HARDCORE=1
export YSU_MESSAGE_POSITION="after"

# Load Oh My Zsh
source $ZSH/oh-my-zsh.sh

# Load custom configurations
source $ZDOTDIR/functions.zsh
source $ZDOTDIR/aliases.zsh

# FZF configuration
source <(fzf --zsh)

# Additional plugins
source $HOMEBREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source $HOMEBREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source $(brew --prefix)/share/zsh-history-substring-search/zsh-history-substring-search.zsh

# Git configuration
unset GIT_CONFIG
autoload -Uz compinit && compinit
zstyle ':completion:*:*:git:*' script "$ZDOTDIR/git-completion.zsh"
fpath=("$ZDOTDIR" $fpath)

# Load NVM
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
