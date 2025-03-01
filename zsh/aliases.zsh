# System Navigation
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

# System Utilities
alias cl='clear'
alias df='df -h'
alias du='du -sh'
alias rm='rm -i'    # Interactive prompt
alias rmd='rm -rfI' # Interactive prompt for large directories

# Dev Shortcuts
alias g='git'
alias v='vim'
alias b='bat --paging=never'

alias p='python3'
alias -s py=python3    # Run Python scripts

alias tl='tldr'
alias type='type -a'

# Package Management (macOS Homebrew)
alias brewcl='brew cleanup && brew autoremove'
alias brewup='brew update && brew upgrade && brew cleanup'  # Update Homebrew & packages

# Networking Aliases
alias myip='curl ifconfig.me' # Get public IP address
alias flushdns='sudo dscacheutil -flushcache; sudo killall -HUP mDNSResponder' # Flush DNS cache (macOS)

# Lazy-load aliases
alias nvm="load_nvm nvm"
alias node="load_nvm node"
alias npm="load_nvm npm"

# Always use color output for `ls`
alias ls='command ls ${colorflag}'
alias l='ls -AFlh ${colorflag}'
alias ll='ls -aFlh ${colorflag}'
alias lsd='ls -lF ${colorflag} | grep --color=never "^d"'

# Always enable colored `grep` output
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

# Empty the Trash and clean logs
alias emptytrash='sudo rm -rfv /Volumes/*/.Trashes; sudo rm -rfv ~/.Trash; sudo rm -rfv /private/var/log/asl/*.asl; sqlite3 ~/Library/Preferences/com.apple.LaunchServices.QuarantineEventsV* "delete from LSQuarantineEvent"'
alias clean-ds='find . -type f -name "*.DS_Store" -ls -delete'
alias cleanup='rmdsstore && emptytrash'
alias lscleanup="/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister -kill -r -domain local -domain system -domain user && killall Finder"

# Spotlight Control
alias spotoff='sudo mdutil -a -i off'
alias spoton='sudo mdutil -a -i on'

# Miscellaneous
alias help='run-help'
alias reload='exec ${SHELL} -l'
alias path='echo -e ${PATH//:/\\n}'
alias relrc='source ${XDG_CONFIG_HOME}/zsh/.zshrc'
