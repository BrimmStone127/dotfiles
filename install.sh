#!/bin/bash

echo "Installing dotfiles..."

# Check if stow is installed
if ! command -v stow &> /dev/null; then
    echo "Error: GNU Stow is not installed"
    echo "Install it with: sudo apt install stow"
    exit 1
fi

# Backup existing configs
backup_dir="$HOME/.dotfiles-backup-$(date +%Y%m%d-%H%M%S)"
mkdir -p "$backup_dir"

[ -f ~/.bashrc ] && mv ~/.bashrc "$backup_dir/"
[ -f ~/.tmux.conf ] && mv ~/.tmux.conf "$backup_dir/"
[ -d ~/.config/nvim ] && mv ~/.config/nvim "$backup_dir/"
[ -f ~/.taskrc ] && mv ~/.taskrc "$backup_dir/"

echo "Backed up existing configs to $backup_dir"

# Stow configurations
stow -v bash
stow -v tmux
stow -v nvim
stow -v task

echo "Dotfiles installed!"
echo "Restart your shell or run: source ~/.bashrc"
