# Dotfiles

Cross-platform development environment for WSL, macOS, and Raspberry Pi.

## Quick Start

On a new machine:

```bash
# Clone the repo
git clone git@github.com:Brimmstone127/dotfiles.git ~/dotfiles
cd ~/dotfiles

# Install dependencies (detects OS automatically)
./bootstrap.sh

# Symlink configs
./install.sh

# Add your API keys
vim ~/.secrets

# Reload shell
source ~/.bashrc
```

## Supported Platforms

| Platform | Status |
|----------|--------|
| WSL2 (Ubuntu) | Full support |
| macOS | Full support |
| Raspberry Pi | Full support |
| Linux (Debian/Ubuntu) | Full support |

## What's Included

- **bash/** - Shell configuration with cross-platform aliases
- **tmux/** - Tmux configuration
- **nvim/** - Neovim configuration (LazyVim-based)
- **task/** - Taskwarrior configuration

## Updating Configs

After making changes on any machine:

```bash
cd ~/dotfiles
git add -A
git commit -m "Update configs"
git push
```

On other machines:

```bash
cd ~/dotfiles
git pull
```

## Secrets Management

API keys and secrets are stored in `~/.secrets` (not tracked in git).

Template: `bash/.secrets.template`

## Adding New Configs

1. Create a directory: `mkdir -p ~/dotfiles/newapp/.config/newapp`
2. Move your config: `mv ~/.config/newapp/* ~/dotfiles/newapp/.config/newapp/`
3. Stow it: `stow -v newapp`
4. Add to `install.sh`

## Requirements

Installed by `bootstrap.sh`:
- GNU Stow
- Git
- Neovim
- Tmux
- Starship prompt
- ripgrep, fzf, bat/batcat, eza/exa
