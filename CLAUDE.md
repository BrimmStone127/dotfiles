# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with this repository.

## Repository Overview

Personal dotfiles for cross-platform development (WSL, macOS, Linux, Raspberry Pi). Uses GNU Stow for symlink management.

## Structure

```
dotfiles/
├── bash/           # Shell config (.bashrc)
├── git/            # Git config (.gitconfig)
├── gh/             # GitHub CLI config
├── nvim/           # Neovim config (LazyVim-based)
├── tmux/           # Tmux config
├── task/           # Taskwarrior config
├── ssh/            # SSH config
├── scripts/        # Custom scripts (note, quick, sync-notes, etc.)
└── templates/      # Project templates
    ├── astro-template/   # Astro + TypeScript + Firestore + Podman
    └── flask-template/   # Flask + Firestore + Podman
```

## Key Commands

```bash
# Install dotfiles on a new machine
./install.sh

# Bootstrap dependencies (installs tools)
./bootstrap.sh

# Create project from template
from-template astro-template my-project
from-template flask-template my-api
```

## Custom Scripts (in ~/.local/bin)

- `note` - Note-taking system with daily notes
- `quick` - Quick capture notes
- `sync-notes` - Sync notes across machines
- `git-log-to-notes` - Log git commits to daily notes
- `tasktemplate` - Task templates for Taskwarrior

## Environment

- **OS Detection**: `$DOTFILES_OS` is set to `macos`, `wsl`, `linux`, or `pi`
- **Secrets**: Store API keys in `~/.secrets` (sourced by bashrc, not tracked in git)
- **Node**: Managed via nvm, default is Node 20
- **Python**: System Python 3.12, use venv for projects

## Templates

### astro-template
- Astro 5 with SSR (Node adapter)
- TypeScript with path aliases
- Firestore with environment-based config
- Podman containerization
- API routes at `src/pages/api/`

### flask-template
- Flask 3 with Gunicorn
- Firestore with environment-based config
- Podman containerization
- pytest, black, ruff, mypy configured
- API routes in `app/routes/`

## When Making Changes

1. Edit files in `~/dotfiles/`, not the symlinked files directly
2. Changes take effect immediately (symlinks)
3. Commit and push to sync across machines
4. Run `./install.sh` on other machines to update
