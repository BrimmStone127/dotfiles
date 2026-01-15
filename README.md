# My Development Environment Dotfiles

Cross-machine configuration for my development environment.

## Quick Start
```bash
git clone https://github.com/yourusername/dotfiles.git ~/dotfiles
cd ~/dotfiles
./install.sh
```

## Manual Installation
```bash
cd ~/dotfiles
stow bash
stow tmux
stow nvim
stow task
source ~/.bashrc
```

## Updating

After making changes to your configs:
```bash
cd ~/dotfiles
git add -A
git commit -m "Update configs"
git push
```

## Contents

- **bash/**: Bash configuration, aliases, and functions
- **tmux/**: Tmux configuration and plugins
- **nvim/**: Neovim configuration (LazyVim-based)
- **task/**: Taskwarrior configuration

## Requirements

- Ubuntu 24.04 (WSL2)
- Neovim 0.10+
- Tmux 3.0+
- Git
- Stow
