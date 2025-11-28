# .bash_profile
# Bash Environment Configuration (Loaded for ALL shell types)                   
#
# Load Enviroment (.env)
if [[ -f "${HOME}/.config/shell/.env" ]]
then
    . "${HOME}/.config/shell/.env"
else
    echo "Warning: Enviroment not set." >&2
fi

# Get the aliases and functions
if [[ -f "${HOME}/.config/bash/.bashrc" ]]
then
    . "${HOME}/.config/bash/.bashrc"
elif [[ -d "${HOME}/.dotfiles" ]]
then
    echo "INFO: Source files dotfiles manually."
else
    echo "Warning: Personal setup not loaded."
fi 

