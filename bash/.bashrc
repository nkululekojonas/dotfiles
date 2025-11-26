# .bashrc
# Bash Interactive Shell Configuration
#
# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# --- Ensure Required Directories Exist  ---
# Only create essential directories that don't exist (faster check)
mkdir -p "${XDG_CONFIG_HOME}/zsh" "${XDG_CACHE_HOME}/zsh"

# Optional: Only create DATA/STATE directories if you use tools that need them
# Uncomment these lines if needed (npm, pipx, cargo, poetry, etc.):
# mkdir -p "${XDG_DATA_HOME}" "${XDG_STATE_HOME}"

# --- PATH Configuration ---
# Set the initial command search path.
export PATH="${PATH}:${HOME}/bin"

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

# --- Source Shared Configurations ---
[[ -f "${XDG_CONFIG_HOME}/shell/.functions" ]] && . "${XDG_CONFIG_HOME}/shell/.functions"
[[ -f "${XDG_CONFIG_HOME}/shell/.aliases" ]] && . "${XDG_CONFIG_HOME}/shell/.aliases"

# --- Bash Options ---
# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# Case-insensitive globbing (used in pathname expansion)
shopt -s nocaseglob;

# # Append to the Bash history file, rather than overwriting it
shopt -s histappend;

# # Autocorrect typos in path names when using `cd`
shopt -s cdspell;

# # Enable some Bash 4 features when possible:
# # * `autocd`, e.g. `**/qux` will enter `./foo/bar/baz/qux`
# # * Recursive globbing, e.g. `echo **/*.txt`
for option in autocd globstar 
do
  shopt -s "$option" 2> /dev/null
done;
