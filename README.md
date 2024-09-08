# Dotfiles

Welcome to my personal dotfiles repository! This collection of configuration files and scripts helps me maintain a consistent and productive development environment across different machines.

## 🚀 Quick Start

```bash
git clone https://github.com/nkululekojonas/dotfiles.git
cd dotfiles
./install.sh
```

## 📦 What's Inside

- `.zshrc`: ZSH shell configuration
- `.vimrc`: Vim editor settings
- `.tmux.conf`: Tmux terminal multiplexer configuration
- `.gitconfig`: Git version control preferences
- `Brewfile`: List of packages to install via Homebrew *TODO*

## 🛠 Installation

1. Clone this repository to your home directory:
   ```
   git clone https://github.com/yourusername/dotfiles.git ~/.dotfiles
   ```
2. Run the installation script:
   ```
   cd ~/.dotfiles
   ./install.sh
   ```

The install script will symlink the appropriate files to your home directory. Make sure to back up your existing dotfiles before running the script.

## ⚙️ Customization

Feel free to modify these dotfiles to suit your preferences. The main configuration files are:

- `zsh/zshrc.symlink` for ZSH settings
- `vim/vimrc.symlink` for Vim configuration
- `git/gitconfig.symlink` for Git setup

After making changes, run `./install.sh` again to update the symlinks.

## 📚 What I Use

- **Shell**: ZSH with [Oh My Zsh](https://ohmyz.sh/)
- **Terminal**: [iTerm2](https://iterm2.com/)
- **Editor**: [Vim](https://www.vim.org/) /[Zed](https://zed.dev) + [Visual Studio Code](https://code.visualstudio.com/)
- **Version Control**: Git
- **Package Manager**: [Homebrew](https://brew.sh/)

## 🤝 Contributing

While these dotfiles are personalized for my use, I'm open to suggestions and improvements! Feel free to fork this repository, make changes, and submit a pull request.

## 📄 License

This project is open source and available under the [MIT License](LICENSE).

## 🙏 Acknowledgments

- Inspired by [Mathias Bynens' dotfiles](https://github.com/mathiasbynens/dotfiles)
- Thanks to the [dotfiles community](https://dotfiles.github.io/) for inspiration and ideas

---
