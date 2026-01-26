#!/bin/bash
# One-liner setup for new machines
# Run with: curl -fsSL https://raw.githubusercontent.com/BrimmStone127/dotfiles/main/setup-remote.sh | bash

set -e

echo "Setting up dotfiles..."

# Install git if missing
if ! command -v git &>/dev/null; then
  echo "Installing git..."
  if [[ "$OSTYPE" == "darwin"* ]]; then
    xcode-select --install 2>/dev/null || true
  else
    sudo apt update && sudo apt install -y git
  fi
fi

# Clone dotfiles
if [ ! -d "$HOME/dotfiles" ]; then
  echo "Cloning dotfiles..."
  git clone https://github.com/BrimmStone127/dotfiles.git "$HOME/dotfiles"
else
  echo "Dotfiles already cloned, pulling latest..."
  cd "$HOME/dotfiles" && git pull
fi

cd "$HOME/dotfiles"

# Run bootstrap and install
echo "Running bootstrap..."
./bootstrap.sh

echo "Running install..."
./install.sh

echo ""
echo "Setup complete! Restart your shell or run: source ~/.bashrc"
