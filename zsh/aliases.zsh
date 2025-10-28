# .aliasrc  : Useful Shell Aliases Portable Across Bash and Zsh 
# Author    : Nkululeko Jonas
# Date      : 23-10-2023

# --- System Navigation ---

alias /='cd /'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'

alias bn='cd ~/bin'
alias tm='cd ~/tmp'
alias dk='cd ~/Desktop'
alias dt='cd ~/dotfiles'
alias dl='cd ~/Downloads'
alias dv='cd ~/Developer'
alias dc='cd ~/Documents'
alias pj='cd ~/Developer/Projects'
alias pg='cd ~/Developer/Playgrounds'

# --- Zsh-specific Aliases ---

if [[ -n ${ZSH_VERSION-} ]]; then

    # Useful Pipeline Shortcuts (Global Alias)
    alias -g B='| bat --paging=never'
    alias -g G='| grep --color=auto'
    alias -g H='| head'
    alias -g L='| less'
    alias -g T='| tail'
    alias -g C='| wc -l'

    alias -g E='2>&1'
    alias -g F='find . -name'
    alias -g DU='du -sh *'

    # File Editing (Vim as default editor)
    alias -s md=vim        # Open Markdown files in Vim
    alias -s txt=vim       # Open text files in Vim
    alias -s yaml=vim      # Open YAML files in Vim
    alias -s conf=vim      # Open config files in Vim

    # File Opening (Default MacOS apps)
    alias -s pdf=open      
    alias -s png=open
    alias -s jpg=open 
    alias -s docx=open     

    # Log & Config File Viewing
    alias -s log='less'        # View log files with less
    alias -s pcap='tcpdump -r' # Read packet captures with tcpdump

    # Shell Help
    alias type='whence -ac'
fi 

# --- System Utilities ---

alias h='history'
alias j='jobs -l'
alias cl='clear'
alias df='df -h'
alias du='du -sh'
alias rmd='rm -rf' 

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
alias vlast='vim -c "normal '\''0"'     # Open vim in the last session

# --- Package Management (macOS Homebrew) ---

alias brewcl='brew cleanup && brew autoremove'
alias brewup='brew update && brew upgrade && brew cleanup'  # Update Homebrew & packages

# --- Grep with Color ---

alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

# --- Tmux Aliases ---

if command -v tmux >/dev/null 2>&1; then

    alias ta='tmux attach -t'
    alias tad='tmux attach -d -t'
    alias ts='tmux new-session -s'
    alias tl='tmux list-sessions'
    alias tksv='tmux kill-server'
    alias tkss='tmux kill-session -t'

fi

# --- Networking Aliases ---

alias myip='curl ifconfig.me'   # Get public IP address

# --- macOS Specific Aliases ---

if [[ "$OSTYPE" == darwin* ]]; then

    # Trash and cleanup
    alias clean-ds='find . -type f -name "*.DS_Store" -ls -delete'
    alias clean-env='clean-ds && emptytrash'
    alias emptytrash='sudo rm -rfv /Volumes/*/.Trashes; sudo rm -rfv ~/.Trash; sudo rm -rfv /private/var/log/asl/*.asl; sqlite3 ~/Library/Preferences/com.apple.LaunchServices.QuarantineEventsV* "delete from LSQuarantineEvent"'
    alias flushdns='sudo dscacheutil -flushcache; sudo killall -HUP mDNSResponder' # Flush DNS cache (macOS)
    
    # Finder
    alias showfiles="defaults write com.apple.finder AppleShowAllFiles YES; killall Finder"
    alias hidefiles="defaults write com.apple.finder AppleShowAllFiles NO; killall Finder"
    
    # Quick Look
    alias ql='qlmanage -p 2>/dev/null'
    
    # Spotlight Control
    alias spotoff='sudo mdutil -a -i off'
    alias spoton='sudo mdutil -a -i on'

fi

# --- Miscellaneous ---

alias b='bat --paging=never'
alias help='run-help'
alias reload='exec ${SHELL} -l'
alias paths='echo ${PATH//:/\\n}'
