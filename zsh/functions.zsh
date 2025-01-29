#!/bin/bash

# functions.zsh: A collection of useful shell functions for enhanced command-line experience
# To use these functions, source this file in your .zshrc:
# source /path/to/functions.zsh

# Create a new directory and enter it
mcd() {
    if [ $# -eq 0 ]; then
        echo "Error: No directory name provided"
        return 1
    fi
    if mkdir -p "$@"; then
        cd "$_" || return 1
    else
        echo "Error: Failed to create directory"
        return 1
    fi
}

# Determine size of a file or total size of a directory
fs() {
    if command -v gdu >/dev/null 2>&1; then
        local du_cmd="gdu"
    else
        local du_cmd="du"
    fi

    if $du_cmd -b /dev/null > /dev/null 2>&1; then
        local arg=-sbh;
    else
        local arg=-sh;
    fi
    if [[ -n "$*" ]]; then
        $du_cmd $arg -- "$@";
    else
        $du_cmd $arg .[^.]* ./*;
    fi;
}

# Generate a random password
genpass() {
    local length=${1:-16}
    LC_ALL=C tr -dc 'A-Za-z0-9!@#$%^&*()_+' </dev/urandom | head -c "$length"
    echo
}

# Show most used commands
topcmds() {
  local num=${1:-10} # Default to showing top 10 commands
  history | awk '{CMD[$2]++; count++;} END {for (a in CMD) print CMD[a], CMD[a]/count*100 "%", a;}' | sort -nr | head -n "$num"
}
