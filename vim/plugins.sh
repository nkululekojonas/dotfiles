#!/bin/bash
PLUGIN_DIR="$HOME/.config/vim/pack/plugins/start"
mkdir -p "$PLUGIN_DIR"
cd "$PLUGIN_DIR"

git clone https://github.com/junegunn/goyo.vim.git
git clone https://github.com/tpope/vim-surround.git
git clone https://github.com/tpope/vim-commentary.git
git clone https://github.com/airblade/vim-gitgutter.git
git clone https://github.com/vim-airline/vim-airline.git
git clone https://github.com/kyoz/purify.git
git clone https://github.com/christoomey/vim-tmux-navigator.git