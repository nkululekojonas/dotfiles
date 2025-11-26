# .zshenv
# Zsh Environment Configuration (Loaded for ALL shell types)                   
#
# --- Zsh Configuration Setup ---
# Load Enviroment (.env)
if [[ -f "${HOME}/.config/shell/.env" ]]
then
    source "${HOME}/.config/shell/.env"
else
    echo "Warning: Couldn't set enviroment." >&2
fi
