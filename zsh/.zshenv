# .zshenv
# Zsh Environment Configuration (Loaded for ALL shell types)                   
#
# --- Zsh Configuration Setup ---
# Tell Zsh where to find its configuration files (using XDG standard)
export ZDOTDIR="${XDG_CONFIG_HOME}/zsh"

# Load Enviroment (.env)
if [[ -f "${XDG_CONFIG_HOME}/shell/.env" ]]
then
    source "${XDG_CONFIG_HOME}/shell/.env"
fi
