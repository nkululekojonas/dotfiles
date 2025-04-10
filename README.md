# Dotfiles

Welcome to my personal dotfiles repository! This collection of configuration files and scripts help me maintain a consistent and productive development environment across different machines.

## 🚀 Quick Start

```bash
git clone https://github.com/nkululekojonas/dotfiles.git
cd dotfiles
./install
```
This will create a .config directory in your home directory if one doesn't already exit, this is where all config files will be stored.

## 📦 Some of What's Inside

- `zshrc`: ZSH shell configuration
- `vimrc`: Vim editor settings
- `tmux.conf`: Tmux terminal multiplexer configuration
- `gitconfig`: Git version control preferences
- `Brewfile`: List of packages to install via Homebrew

This includes some custom functions and personal aliases located in zsh/.

## 🛠 Installation

1. Clone this repository to your home directory:
   ```
   git clone https://github.com/nkululekojonas/dotfiles.git ~/dotfiles
   ```
2. Run the installation script:
   ```
   cd ~/dotfiles
   ./install
   ```
The install script will symlink the appropriate files to your home directory. Make sure to back up your existing dotfiles before running the script.

## 🛠 Dry Run
1. Run the installing script with --dry-run flag
    ```
    cd ~/dotfiles
    ./install --dry-run
    ```
    This will will output the changes that will occur if there are any, this will also report any errors that occur, recommend running this first.

## ⚙️ Customization

Feel free to modify these dotfiles to suit your preferences. The main configuration files are:

- `zsh/zshrc` for ZSH settings
- `tmux/tmux.conf` for Tmux configuration
- `vim/vimrc` for Vim configuration
- `git/gitconfig` for Git configuration

After making changes, run `./install` again to update the symlinks.

## TODO

- [ ] Add oh-my-zsh installation 
- [ ] Check for broken symlinks
- [ ] Add a `--help` flag

## 📚 What I Use

- **Shell**: ZSH with [Oh My Zsh](https://ohmyz.sh/)
- **Terminal**: [iTerm2](https://iterm2.com/)
- **Editor**: [Vim](https://www.vim.org/) 
- **Version Control**: Git
- **Package Manager**: [Homebrew](https://brew.sh/)

## 🤝 Contributing

While these dotfiles are personalized for my use, I'm open to suggestions and improvements! This is an ever changing repo of my personal preferences but feel free to fork this repository, make changes, and submit a pull request.

## 📄 License

This project is open source and available under the [MIT License](LICENSE).

## 🙏 Acknowledgments

- Inspired by [Mathias Bynens' dotfiles](https://github.com/mathiasbynens/dotfiles)
- Thanks to the [dotfiles community](https://dotfiles.github.io/) for inspiration and ideas

---
