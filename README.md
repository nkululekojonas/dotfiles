# Dotfiles

Welcome to my personal dotfiles repository! This collection of configuration files and scripts help me maintain a consistent and productive development environment across different machines.

## 🚀 Quick Start

```bash
git clone https://github.com/nkululekojonas/dotfiles.git ~/dotfiles
cd ~/dotfiles
./install
```

> [!NOTE] 
> This assumes `$HOME` doesn't have a directory named `dotfiles` or that it's empty.

> [!NOTE]
> This will create a .config directory in your home directory if one doesn't already exit, this is where all config files will be stored.

## 📦 What's Inside

- `bash` : Bash shell configuation
- `zshrc`: Zsh shell configuration
- `shell` : A collection of portable shell functions and aliases
- `brew` : A Homebrew installation script
- `macos` : Sensible masOS defaults
- `vimrc`: Vim editor settings
- `tmux.conf`: Tmux terminal multiplexer configuration
- `git`: Git preferences
- `Brewfile`: List of packages to install via Homebrew

## 🛠 Installation

1. Clone this repository to your home directory:

```bash
git clone https://github.com/nkululekojonas/dotfiles.git ~/dotfiles
```

    > [!NOTE] 
    > This will fail if a non-empty `/dotfiles` exists in `$HOME`

2. Run the installation script:

```bash
cd ~/dotfiles
./install
```

    The install script will symlink the appropriate files to your home directory. Make sure to back up your existing dotfiles before running the script.

## 🛠 Dry Run
1. Run the installing script with --dry-run flag

```bash
./install --dry-run
```

This will will output the changes that will occur if there are any, this will also report any errors that occur, recommend running this first.

## ⚙️ Customization

Feel free to modify these dotfiles to suit your preferences. The main configuration files are:

- `zsh/zshrc` for ZSH settings
- `tmux/tmux.conf` for Tmux configuration
- `vim/vimrc` for Vim configuration
- `git/gitconfig` for Git configuration

### Sensible macOS defaults

When setting up a new Mac, you may want to set some sensible macOS defaults:

```bash
./.macos
```

### Install Homebrew formulae

When setting up a new Mac, you may want to install some common [Homebrew](https://brew.sh/) formulae (after installing Homebrew, of course):

```bash
./brew.sh
```

Some of the functionality of these dotfiles depends on formulae installed by `brew.sh`. If you don’t plan to run `brew.sh`, you should look carefully through the script and manually install any particularly important ones. A good example is Bash/Git completion: the dotfiles use a special version from Homebrew.
After making changes, run `./install` again to update the symlinks.

## TODO

- [ ] Add oh-my-zsh installation 
- [ ] Check for broken symlinks
- [ ] Add a `--help` flag

## 🤝 Contributing

While these dotfiles are personalized for my use, I'm open to suggestions and improvements! This is an ever changing repo of my personal preferences but feel free to fork this repository, make changes, and submit a pull request.

## 📄 License

This project is open source and available under the [MIT License](LICENSE).

## 🙏 Acknowledgments

- Inspired by [Mathias Bynens' dotfiles](https://github.com/mathiasbynens/dotfiles)
- Thanks to the [dotfiles community](https://dotfiles.github.io/) for inspiration and ideas

---
