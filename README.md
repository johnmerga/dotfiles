# Dotfiles

Personal dotfiles for configuring my development environment.

---

## Description

This repository contains my dotfiles for **bash**, **zsh**, **tmux**, and other utilities.  
It uses **GNU Stow** to manage symlinks and keep everything organized.

---

## Setup Instructions

### 1. Clone the repository

```bash
git clone https://github.com/johnmerga/dotfiles ~/dotfiles
cd ~/dotfiles
```

### 2. Install GNU Stow (if not already installed)

On Ubuntu/Debian:

```bash
sudo apt update
sudo apt install stow
```

On Arch/Manjaro:

```bash
sudo pacman -S stow
```

### 3. Symlink dotfiles using Stow

```bash
cd ~/dotfiles

# Stow individual packages
stow bash
stow zsh
stow config
stow bin
```

Each stow command will create symlinks in your home directory pointing to the dotfiles.

### 4. Setup tmux and TPM (Tmux Plugin Manager)

Clone TPM into the tmux plugins directory:

```bash
git clone https://github.com/tmux-plugins/tpm ~/.config/tmux/plugins/tpm
```

Source your tmux configuration:

```bash
tmux source ~/dotfiles/config/.config/tmux/tmux.conf
```

Inside tmux, install plugins:

Start tmux:

```bash
tmux
```

Press your prefix (Alt + a) then I (capital i) to install plugins.

Once installed, your tmux setup is ready.

### Notes

- This setup assumes you are on Linux and have a standard home directory.
- If you already have conflicting files, you may need to remove them before stowing.
- Each folder in this repo is treated as a package for stow (bash, zsh, config, bin).

```

```
