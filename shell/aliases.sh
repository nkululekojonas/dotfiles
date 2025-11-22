# .aliasrc  : Useful Shell Aliases Portable Across Bash and Zsh 
# Author    : Nkululeko Jonas
# Date      : 23-10-2023

# --- Shell Variables ---
# Define OS variables for cleaner checks
case "$OSTYPE" in
    darwin*) is_macos=true ;;
    linux*) is_linux=true ;;
    *) ;;
esac

# --- System Navigation ---

alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'

# --- System Utilities (Functions used for OS-specific command flags) ---

alias h='history'
alias j='jobs -l'
alias cl='clear'
alias rmd='rm -rf'

# --- Grep with Color ---

alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

# --- Python aliases ---

alias p='python3'
alias py='python3'
alias python='python3'
alias pip='pip3'
alias pipup='pip install --upgrade pip'
alias venv='python -m venv'
alias activate='source venv/bin/activate'

# --- Vim aliases ---

alias v='vim'
alias vi='vim'

# --- Miscellaneous ---

alias reload='exec ${SHELL} -l'
alias paths='echo ${PATH//:/\\n}'

# --- Networking Aliases ---

alias myip='curl ifconfig.me'

# --- Zsh-specific Aliases ---

if [[ -n ${ZSH_VERSION-} ]]
then
    # System nagivation
    alias /='cd /'

    # Useful Pipeline Shortcuts (Global Alias)
    alias -g B='| bat --paging=never'
    alias -g G='| grep --color=auto'
    alias -g H='| head'
    alias -g L='| less'
    alias -g S='| sort'
    alias -g T='| tail'
    alias -g U='| uniq'
    alias -g C='| wc -l'

    alias -g E='2>&1'
    alias -g F='find . -name'
    alias -g DU='du -sh *'

    # Suffix Aliases
    alias -s md=vim
    alias -s txt=vim
    alias -s yaml=vim
    alias -s conf=vim
    alias -s pdf=open
    alias -s png=open
    alias -s jpg=open
    alias -s docx=open
    alias -s log='less'
    alias -s pcap='tcpdump -r'

    # Shell Help
    alias b='bat --paging=never'
    alias type='whence -ac'
    alias help='run-help'
fi

# --- Tmux Aliases (Conditional on installation) ---

if command -v tmux &> /dev/null
then
    alias ta='tmux attach -t'
    alias tad='tmux attach -d -t'
    alias ts='tmux new-session -s'
    alias tl='tmux list-sessions'
    alias tksv='tmux kill-server'
    alias tkss='tmux kill-session -t'
fi

# --- macOS Specific Aliases (Conditional on OSTYPE) ---

if [[ -n ${is_macos} ]]
then
    # System Naviagtion
    alias bn='cd ~/bin'
    alias tm='cd ~/tmp'
    alias dk='cd ~/Desktop'
    alias dt='cd ~/dotfiles'
    alias dl='cd ~/Downloads'
    alias dv='cd ~/Developer'
    alias dc='cd ~/Documents'
    alias pj='cd ~/Developer/Projects'
    alias pg='cd ~/Developer/Playgrounds'

    # Package Management (macOS Homebrew)
    alias brewcl='brew cleanup && brew autoremove'
    alias brewup='brew update && brew upgrade && brew cleanup'

    # Trash and cleanup
    alias clean-ds='find . -type f -name "*.DS_Store" -ls -delete'
    alias clean-env='clean-ds && emptytrash'
    alias emptytrash='sudo rm -rfv /Volumes/*/.Trashes; sudo rm -rfv ~/.Trash; sudo rm -rfv /private/var/log/asl/*.asl; sqlite3 ~/Library/Preferences/com.apple.LaunchServices.QuarantineEventsV* "delete from LSQuarantineEvent"'
    alias flushdns='sudo dscacheutil -flushcache; sudo killall -HUP mDNSResponder'

    # Finder
    alias showfiles="defaults write com.apple.finder AppleShowAllFiles YES; killall Finder"
    alias hidefiles="defaults write com.apple.finder AppleShowAllFiles NO; killall Finder"

    # Quick Look
    alias ql='qlmanage -p 2>/dev/null'

    # Spotlight Control
    alias spotoff='sudo mdutil -a -i off'
    alias spoton='sudo mdutil -a -i on'
fi
