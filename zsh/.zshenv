# .zshenv
# Zsh Environment Configuration (Loaded for ALL shell types)                   
#
# --- Zsh Configuration Setup ---
# Load Enviroment (.env)
if [[ -f "${XDG_CONFIG_HOME}/shell/.env" ]]
then
    source "${XDG_CONFIG_HOME}/shell/.env"
fi
