# Navigation Aliases
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."
alias /='cd /'
alias cdback="cd -"

# System Shortcuts
alias c='clear'
alias cl='clear'
alias rm='rm -rfI'  # Interactive prompt for safety
alias bin="cd ~/bin"
alias dot="cd ~/dotfiles"
alias dt="cd ~/Desktop"
alias dl="cd ~/Downloads"
alias dv="cd ~/Developer"
alias app="cd ~/Applications"
alias als="$EDITOR ~/.zsh/aliases.zsh"
alias docs="cd ~/Documents"
alias zshconfig="$EDITOR ~/.zsh/.zshrc"

# Dev Shortcuts
alias b='bat --paging=never'
alias g='git'
alias p='python3'
alias v='vim'
alias python='python3'
alias pip='python -m pip'
alias venv='python -m venv'
alias vactivate='source venv/bin/activate'  # Activate venv alias
alias bat='bat --paging=never'
alias cat='bat --paging=never'
alias opv='vim $(fzf --preview "bat --color=always --style=numbers --line-range=:500 {}")'

# Detect which `ls` flavor is in use
if ls --color > /dev/null 2>&1; then # GNU `ls`
    colorflag="--color"
    export LS_COLORS='no=00:fi=00:di=01;31:ln=01;36:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arj=01;31:*.taz=01;31:*.lzh=01;31:*.zip=01;31:*.z=01;31:*.Z=01;31:*.gz=01;31:*.bz2=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.jpg=01;35:*.jpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.avi=01;35:*.fli=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.ogg=01;35:*.mp3=01;35:*.wav=01;35:'
else # macOS `ls`
    colorflag="-G"
    export LSCOLORS='BxBxhxDxfxhxhxhxhxcxcx'
fi

# List all files colorized in long format
alias l="ls -lh ${colorflag}"

# List all files colorized in long format, excluding . and ..
alias ll="ls -lAh ${colorflag}"

# List only directories
alias lsd="ls -lF ${colorflag} | grep --color=never '^d'"

# Always use color output for `ls`
alias ls="command ls ${colorflag}"

# Always enable colored `grep` output
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

# Maintenance & Cleanup
alias update='sudo softwareupdate -i -a && brew doctor && brew update && brew upgrade && brew cleanup && mas upgrade'
alias afk="/System/Library/CoreServices/Menu\ Extras/User.menu/Contents/Resources/CGSession -suspend"
alias emptytrash="sudo rm -rfv /Volumes/*/.Trashes; sudo rm -rfv ~/.Trash; sudo rm -rfv /private/var/log/asl/*.asl; sqlite3 ~/Library/Preferences/com.apple.LaunchServices.QuarantineEventsV* 'delete from LSQuarantineEvent'"
alias cleanup="find . -type f -name '*.DS_Store' -ls -delete"
alias lscleanup="/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister -kill -r -domain local -domain system -domain user && killall Finder"

# Spotlight Control
alias spotoff="sudo mdutil -a -i off"
alias spoton="sudo mdutil -a -i on"

# Reload the shell (i.e. invoke as a login shell)
alias reload="exec ${SHELL} -l"

# Print each PATH entry on a separate line
alias path='echo -e ${PATH//:/\\n}'
