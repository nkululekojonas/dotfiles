# .bashrc
# Bash Interactive Shell Configuration
#
# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# --- Ensure Required Directories Exist  ---
# Only create essential directories that don't exist 
mkdir -p "$(dirname "$HISTFILE")"
mkdir -p "${XDG_CONFIG_HOME}" "${XDG_CACHE_HOME}"

# Optional: Only create DATA/STATE directories if you use tools that need them
# Uncomment these lines if needed (npm, pipx, cargo, poetry, etc.):
# mkdir -p "${XDG_DATA_HOME}" "${XDG_STATE_HOME}"

# --- PATH Configuration ---
# Set the initial command search path.
[[ -d "${HOME}/bin" ]] && export PATH="${PATH}:${HOME}/bin"

# --- Set DOTFILES Variable ---
[[ -d "${HOME}/.dotfiles" ]] && export DOTFILES="${HOME}/.dotfiles"

# --- Bash Options ---
# Completion
shopt -s nocaseglob      # Case-insensitive globbing
shopt -s cdspell         # Auto-correct minor typos in cd
shopt -s dirspell        # Auto-correct directory names during completion
shopt -s dotglob         # Include dotfiles in globbing (like GLOB_DOTS)
shopt -s extglob         # Extended pattern matching (like EXTENDED_GLOB)

# History
shopt -s histappend      # Append to history file, don't overwrite
shopt -s cmdhist         # Save multi-line commands as one history entry

# --- Prompt (PS1) ---
if [[ -f "${XDG_CONFIG_HOME}/bash/.bash_prompt" ]] 
then
    . "${XDG_CONFIG_HOME}/bash/.bash_prompt"
elif [[ ${EUID} == 0 ]]
then
    PS1='\[\033[01;31m\]\u@\h\[\033[01;34m\] \w \$\[\033[00m\] '
else
    PS1='\[\033[01;32m\]\u@\h\[\033[01;34m\] \w \$\[\033[00m\] '
fi

# --- Completion ---
# Enable programmable completion
if ! shopt -oq posix; then
    if [[ -f /usr/share/bash-completion/bash_completion ]]; then
        source /usr/share/bash-completion/bash_completion
    elif [[ -f /etc/bash_completion ]]; then
        source /etc/bash_completion
    elif [[ -f /opt/homebrew/etc/profile.d/bash_completion.sh ]]; then
        source /opt/homebrew/etc/profile.d/bash_completion.sh
    fi
fi

# --- Source Shared Configurations ---
[[ -f "${XDG_CONFIG_HOME}/shell/.functions" ]] && . "${XDG_CONFIG_HOME}/shell/.functions"
[[ -f "${XDG_CONFIG_HOME}/shell/.aliases" ]] && . "${XDG_CONFIG_HOME}/shell/.aliases"
