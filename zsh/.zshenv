# Set PATH priority and add ~/bin and ~/tmp to $PATH
case ":$PATH:" in
    *:"$HOME/bin":*) ;;
    *) PATH="$HOME/bin:$PATH";;
esac
case ":$PATH:" in
    *:"$HOME/tmp":*) ;;
    *) PATH="$HOME/tmp:$PATH";;
esac

# Set XDG Base Directory specification directories
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"
export XDG_RUNTIME_DIR="$HOME/.local/run"

# Set custom location for zsh configuration files
export ZDOTDIR="$HOME/.zsh"
if [[ ! -d "$ZDOTDIR" ]]; then
    mkdir -p "$ZDOTDIR"
fi

# Set default editor
export EDITOR="vim"
export VISUAL="vim"

# Set default pager
export PAGER="less"

# Configure less
export LESS="-R -i -g -c -W -M -J"
export LESSHISTFILE="-"

# Set preferred language and locale
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# Move the Python interactive shell history file to the .config directory
export PYTHONSTARTUP="$XDG_CONFIG_HOME/python/pythonrc"
export PYTHONHISTORY="$XDG_CONFIG_HOME/python/history"
if [[ ! -d "$XDG_CONFIG_HOME/python" ]]; then
    mkdir -p "$XDG_CONFIG_HOME/python"
fi

# Configure Vim to use XDG compliant directory for vimrc
if [[ ! -d "$XDG_CONFIG_HOME/vim" ]]; then
    mkdir -p "$XDG_CONFIG_HOME/vim"
fi
export VIMINIT='let $MYVIMRC="$XDG_CONFIG_HOME/vim/vimrc" | source $MYVIMRC'
