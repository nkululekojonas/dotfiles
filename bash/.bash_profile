# .bash_profile
# Bash Environment Configuration (Loaded for ALL shell types)                   
#
# Load Enviroment (.env)
if [[ -f "${HOME}/.config/shell/.env" ]]
then
    . "${HOME}/.config/shell/.env"
fi

# Get the aliases and functions
if [[ -f "${XDG_CONFIG_HOME}/bash/.bashrc" ]]
then
    . "${XDG_CONFIG_HOME}/bash/.bashrc"
fi

