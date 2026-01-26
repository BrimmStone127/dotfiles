#!/bin/bash

set -e

echo "Installing dotfiles..."

# Detect OS
detect_os() {
  if [[ "$OSTYPE" == "darwin"* ]]; then
    echo "macos"
  elif [[ -f /proc/version ]] && grep -qi microsoft /proc/version 2>/dev/null; then
    echo "wsl"
  elif [[ -f /etc/rpi-issue ]] || [[ $(uname -m) == "aarch64" || $(uname -m) == "armv7l" ]]; then
    echo "pi"
  else
    echo "linux"
  fi
}

OS=$(detect_os)
echo "Detected OS: $OS"

# Check if stow is installed
if ! command -v stow &> /dev/null; then
  echo "Error: GNU Stow is not installed"
  case $OS in
    macos)
      echo "Install it with: brew install stow"
      ;;
    *)
      echo "Install it with: sudo apt install stow"
      ;;
  esac
  exit 1
fi

# Get the directory where this script lives
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$DOTFILES_DIR"

# Backup existing configs
backup_dir="$HOME/.dotfiles-backup-$(date +%Y%m%d-%H%M%S)"
mkdir -p "$backup_dir"

backup_if_exists() {
  local file="$1"
  if [ -e "$file" ] && [ ! -L "$file" ]; then
    mv "$file" "$backup_dir/"
    echo "Backed up: $file"
  elif [ -L "$file" ]; then
    rm "$file"
    echo "Removed symlink: $file"
  fi
}

backup_if_exists "$HOME/.bashrc"
backup_if_exists "$HOME/.tmux.conf"
backup_if_exists "$HOME/.config/nvim"
backup_if_exists "$HOME/.taskrc"

# Remove backup dir if empty
rmdir "$backup_dir" 2>/dev/null && echo "No backups needed" || echo "Backed up existing configs to $backup_dir"

# Ensure .config exists
mkdir -p "$HOME/.config"

# Stow configurations
echo "Stowing configurations..."
stow -v -t "$HOME" bash
stow -v -t "$HOME" tmux
stow -v -t "$HOME" nvim
stow -v -t "$HOME" task

# Set up secrets file if it doesn't exist
if [ ! -f "$HOME/.secrets" ]; then
  echo "Creating ~/.secrets from template..."
  cp "$DOTFILES_DIR/bash/.secrets.template" "$HOME/.secrets"
  chmod 600 "$HOME/.secrets"
  echo "IMPORTANT: Edit ~/.secrets to add your API keys"
fi

echo ""
echo "Dotfiles installed successfully!"
echo ""
echo "Next steps:"
echo "  1. Edit ~/.secrets to add your API keys"
echo "  2. Restart your shell or run: source ~/.bashrc"
echo ""
echo "To install dependencies, run: ./bootstrap.sh"
