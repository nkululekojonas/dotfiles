# .bash_profile
# Bash Environment Configuration (Loaded for ALL shell types)                   
#
# Load Enviroment (.env)
if [[ -f "${XDG_CONFIG_HOME}/shell/.env" ]]
then
    . "${XDG_CONFIG_HOME}/shell/.env"
fi

# Get the aliases and functions
if [ -f ~/.bashrc ]; then
	. ~/.bashrc
fi

