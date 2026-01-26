#!/bin/bash

set -e

echo "Bootstrapping development environment..."

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

# Common packages needed on all platforms
COMMON_PACKAGES=(
  git
  stow
  tmux
  ripgrep
  fzf
  jq
  curl
  wget
)

# Install Homebrew on macOS if not present
install_homebrew() {
  if ! command -v brew &>/dev/null; then
    echo "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    eval "$(/opt/homebrew/bin/brew shellenv 2>/dev/null || /usr/local/bin/brew shellenv)"
  fi
}

# macOS installation
install_macos() {
  install_homebrew

  echo "Installing packages with Homebrew..."
  brew install "${COMMON_PACKAGES[@]}"
  brew install neovim
  brew install eza        # better ls (successor to exa)
  brew install bat        # better cat
  brew install starship   # prompt
  brew install task       # taskwarrior

  # Optional: install nerd font for icons
  echo "Installing Nerd Font..."
  brew install --cask font-meslo-lg-nerd-font
}

# Debian/Ubuntu installation (WSL, Pi, Linux)
install_debian() {
  echo "Updating apt..."
  sudo apt update

  echo "Installing packages with apt..."
  sudo apt install -y "${COMMON_PACKAGES[@]}"
  sudo apt install -y build-essential
  sudo apt install -y bat         # better cat (called batcat)
  sudo apt install -y exa         # better ls (may need to use eza on newer systems)
  sudo apt install -y taskwarrior # task management
  sudo apt install -y xclip       # clipboard support for tmux

  # Install starship
  if ! command -v starship &>/dev/null; then
    echo "Installing Starship prompt..."
    curl -sS https://starship.rs/install.sh | sh -s -- -y
  fi

  # Install neovim (latest stable)
  install_neovim_linux
}

# Install Neovim on Linux
install_neovim_linux() {
  if command -v nvim &>/dev/null; then
    echo "Neovim already installed: $(nvim --version | head -1)"
    return
  fi

  echo "Installing Neovim..."

  case $(uname -m) in
    x86_64)
      # x86_64 Linux
      curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz
      sudo rm -rf /opt/nvim-linux64
      sudo tar -C /opt -xzf nvim-linux64.tar.gz
      rm nvim-linux64.tar.gz
      echo "Neovim installed to /opt/nvim-linux64"
      ;;
    aarch64|armv7l)
      # ARM (Raspberry Pi)
      # Build from source or use apt version
      echo "Installing Neovim from apt (may not be latest)..."
      sudo apt install -y neovim
      ;;
  esac
}

# Raspberry Pi specific setup
install_pi() {
  install_debian

  echo "Raspberry Pi specific setup..."
  # Add any Pi-specific packages here
}

# Run installation based on OS
case $OS in
  macos)
    install_macos
    ;;
  wsl|linux)
    install_debian
    ;;
  pi)
    install_pi
    ;;
esac

echo ""
echo "Bootstrap complete!"
echo ""
echo "Next steps:"
echo "  1. Run ./install.sh to symlink dotfiles"
echo "  2. Edit ~/.secrets to add your API keys"
echo "  3. Restart your shell"
