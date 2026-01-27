# ~/.bashrc: executed by bash(1) for non-login shells.
# Cross-platform dotfiles for WSL, macOS, and Linux (Raspberry Pi)

# If not running interactively, don't do anything
case $- in
*i*) ;;
*) return ;;
esac

# ============================================
# OS Detection
# ============================================
export DOTFILES_OS="unknown"
if [[ "$OSTYPE" == "darwin"* ]]; then
  export DOTFILES_OS="macos"
elif [[ -f /proc/version ]] && grep -qi microsoft /proc/version 2>/dev/null; then
  export DOTFILES_OS="wsl"
elif [[ -f /etc/rpi-issue ]] || [[ $(uname -m) == "aarch64" || $(uname -m) == "armv7l" ]]; then
  export DOTFILES_OS="pi"
else
  export DOTFILES_OS="linux"
fi

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
  debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
xterm-color | *-256color) color_prompt=yes ;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
  if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
    # We have color support; assume it's compliant with Ecma-48
    # (ISO/IEC-6429). (Lack of such support is extremely rare, and such
    # a case would tend to support setf rather than setaf.)
    color_prompt=yes
  else
    color_prompt=
  fi
fi

if [ "$color_prompt" = yes ]; then
  PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
  PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm* | rxvt*)
  PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
  ;;
*) ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
  test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
  alias ls='ls --color=auto'
  #alias dir='dir --color=auto'
  #alias vdir='vdir --color=auto'

  alias grep='grep --color=auto'
  alias fgrep='fgrep --color=auto'
  alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
  . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

export PATH="$HOME/.local/bin:$PATH"

# Platform-specific paths
if [[ "$DOTFILES_OS" == "macos" ]]; then
  # Homebrew paths
  eval "$(/opt/homebrew/bin/brew shellenv 2>/dev/null || /usr/local/bin/brew shellenv 2>/dev/null)"
elif [[ "$DOTFILES_OS" == "wsl" || "$DOTFILES_OS" == "linux" ]]; then
  # Neovim path for Linux
  [ -d /opt/nvim-linux64/bin ] && export PATH="$PATH:/opt/nvim-linux64/bin"
elif [[ "$DOTFILES_OS" == "pi" ]]; then
  # Neovim path for ARM
  [ -d /opt/nvim/bin ] && export PATH="$PATH:/opt/nvim/bin"
fi

# Initialize starship prompt if available
command -v starship &>/dev/null && eval "$(starship init bash)"

# ============================================
# Custom Aliases and Functions
# ============================================

# Better ls (eza > exa > ls)
if command -v eza &>/dev/null; then
  alias ls='eza --icons'
  alias ll='eza -l --icons'
  alias la='eza -la --icons'
  alias lt='eza --tree --icons'
elif command -v exa &>/dev/null; then
  alias ls='exa --icons'
  alias ll='exa -l --icons'
  alias la='exa -la --icons'
  alias lt='exa --tree --icons'
elif [[ "$DOTFILES_OS" == "macos" ]]; then
  alias ls='ls -G'
  alias ll='ls -lahG'
  alias la='ls -AG'
else
  alias ls='ls --color=auto'
  alias ll='ls -lah --color=auto'
  alias la='ls -A --color=auto'
fi

# Better cat (bat is called batcat on Debian/Ubuntu)
if command -v batcat &>/dev/null; then
  alias cat='batcat --style=plain'
  alias ccat='batcat'
elif command -v bat &>/dev/null; then
  alias cat='bat --style=plain'
  alias ccat='bat'
fi

# Better grep
alias grep='grep --color=auto'

# Git shortcuts
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gl='git log --oneline --graph --decorate'
alias gd='git diff'

# Navigation shortcuts
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias projects='cd ~/projects'
alias notes='cd ~/notes'

# Tmux shortcuts
alias tn='tmux new -s'
alias tl='tmux ls'
alias ta='tmux attach -t'
alias tk='tmux kill-session -t'

# Neovim
alias vim='nvim'
alias vi='nvim'
alias v='nvim'

# Development
alias python='python3'
alias pip='pip3'

# Quick edit common files
alias bashrc='nvim ~/.bashrc'
alias tmuxconf='nvim ~/.tmux.conf'
alias vimrc='nvim ~/.config/nvim/lua/config/custom.lua'

# OS-specific open command
if [[ "$DOTFILES_OS" == "wsl" ]]; then
  alias open='explorer.exe'
  alias clip='clip.exe'
elif [[ "$DOTFILES_OS" == "macos" ]]; then
  alias clip='pbcopy'
  # open is native on macOS
elif [[ "$DOTFILES_OS" == "linux" || "$DOTFILES_OS" == "pi" ]]; then
  alias open='xdg-open'
  command -v xclip &>/dev/null && alias clip='xclip -selection clipboard'
fi

# Useful functions

# Create directory and cd into it
mkcd() {
  mkdir -p "$1" && cd "$1"
}

# Find and replace in files
replace() {
  if [ -z "$1" ] || [ -z "$2" ]; then
    echo "Usage: replace 'find' 'replace' [path]"
    return 1
  fi
  rg "$1" -l "${3:-.}" | xargs sed -i "s/$1/$2/g"
}

# Quick project setup
newproject() {
  if [ -z "$1" ]; then
    echo "Usage: newproject <name>"
    return 1
  fi
  mkcd ~/projects/"$1"
  git init
  echo "# $1" >README.md
  nvim README.md
}

# Find in files
findin() {
  rg -i "$1" "${2:-.}"
}

# Quick git commit
qc() {
  git add -A
  git commit -m "$1"
}

# Start dev session in tmux
dev() {
  if [ -z "$1" ]; then
    echo "Usage: dev <session-name>"
    return 1
  fi

  tmux new-session -d -s "$1"
  tmux rename-window -t "$1:1" "editor"
  tmux send-keys -t "$1:1" "nvim" C-m
  tmux new-window -t "$1:2" -n "terminal"
  tmux new-window -t "$1:3" -n "server"
  tmux select-window -t "$1:1"
  tmux attach-session -t "$1"
}

# Taskwarrior aliases
alias t='task'
alias ta='task add'
alias tl='task list'
alias td='task done'
alias tw='task list project:work'
alias tt='task list +today'
alias tn='task list +next'

# Quick add with common tags
alias taw='task add project:work'
alias tap='task add project:personal'
# Load local secrets (API keys, etc.) - not tracked in git
if [ -f ~/.secrets ]; then
  source ~/.secrets
fi

# Note alias
alias n='note'
alias nw='note work'
alias nt='note todo'
alias ni='note ideas'
alias ny='note yesterday'

alias q='quick'

alias ns='note -s' #Search: ns "fishing"
alias nl='note -l' #list all notes

alias weekly='weekly-summary'
alias nsync='sync-notes'

# WSLg display support
if [[ "$DOTFILES_OS" == "wsl" ]] && [[ -d /mnt/wslg ]]; then
  export DISPLAY=:0
  export WAYLAND_DISPLAY=wayland-0
  export XDG_RUNTIME_DIR=/mnt/wslg/runtime-dir
  export PULSE_SERVER=/mnt/wslg/PulseServer
fi

# Godot development
# Set GODOT in ~/.secrets to override auto-detection
export GODOT_PROJECTS="${GODOT_PROJECTS:-$HOME/projects}"

# Auto-detect Godot if not set
if [[ -z "$GODOT" ]]; then
  if [[ "$DOTFILES_OS" == "wsl" ]]; then
    # Look for Windows Godot (prefer console version for terminal output)
    for godot_path in \
      "/mnt/c/Program Files/Godot/Godot"*"_console.exe" \
      "/mnt/c/Program Files/Godot/Godot"*".exe" \
      "/mnt/c/Godot/Godot"*"_console.exe" \
      "/mnt/c/Godot/Godot"*".exe" \
      "$HOME/tools/Godot"*"_console.exe" \
      "$HOME/tools/Godot"*".exe"; do
      [[ -f "$godot_path" ]] && export GODOT="$godot_path" && break
    done
  elif [[ "$DOTFILES_OS" == "macos" ]]; then
    # macOS Godot locations
    for godot_path in \
      "/Applications/Godot.app/Contents/MacOS/Godot" \
      "$HOME/Applications/Godot.app/Contents/MacOS/Godot"; do
      [[ -f "$godot_path" ]] && export GODOT="$godot_path" && break
    done
  elif [[ "$DOTFILES_OS" == "linux" || "$DOTFILES_OS" == "pi" ]]; then
    # Linux Godot locations
    for godot_path in \
      "$HOME/tools/Godot"*".x86_64" \
      "$HOME/tools/Godot"*".64" \
      "/usr/local/bin/godot" \
      "/usr/bin/godot"; do
      [[ -f "$godot_path" ]] && export GODOT="$godot_path" && break
    done
  fi
fi

# Only define functions if Godot is available
if [[ -n "$GODOT" ]]; then
  # Helper to convert paths for Windows Godot on WSL
  _godot_path() {
    if [[ "$DOTFILES_OS" == "wsl" ]]; then
      wslpath -w "$1"
    else
      echo "$1"
    fi
  }

  # Helper to list projects
  _godot_list_projects() {
    echo "Godot projects:"
    if [[ "$DOTFILES_OS" == "macos" ]]; then
      find "$GODOT_PROJECTS" -maxdepth 2 -name "project.godot" 2>/dev/null | xargs -I{} dirname {} | xargs -I{} basename {}
    else
      find "$GODOT_PROJECTS" -maxdepth 2 -name "project.godot" -printf "  %h\n" 2>/dev/null | xargs -I{} basename {}
    fi
  }

  # godot [project] - open project in editor, or list projects if no arg
  godot() {
    if [ -z "$1" ]; then
      _godot_list_projects
      return
    fi

    local project_path="$GODOT_PROJECTS/$1"
    if [ -f "$project_path/project.godot" ]; then
      cd "$project_path"
      "$GODOT" --path "$(_godot_path "$(pwd)")" --editor &>/dev/null &
      echo "Opening $1 in Godot..."
    else
      echo "Project not found: $1"
      _godot_list_projects
    fi
  }

  # godot-run [project] - run project without editor
  godot-run() {
    local project_path="${1:-.}"
    [ -d "$GODOT_PROJECTS/$1" ] && project_path="$GODOT_PROJECTS/$1"

    # Convert to absolute path if relative
    if [[ "$project_path" != /* ]]; then
      project_path="$(cd "$project_path" 2>/dev/null && pwd)"
    fi

    "$GODOT" --path "$(_godot_path "$project_path")" &
  }

  # Tab completion for godot command
  _godot_completions() {
    local projects
    if [[ "$DOTFILES_OS" == "macos" ]]; then
      projects=$(find "$GODOT_PROJECTS" -maxdepth 2 -name "project.godot" 2>/dev/null | xargs -I{} dirname {} | xargs -I{} basename {})
    else
      projects=$(find "$GODOT_PROJECTS" -maxdepth 2 -name "project.godot" -printf "%h\n" 2>/dev/null | xargs -I{} basename {})
    fi
    COMPREPLY=($(compgen -W "$projects" -- "${COMP_WORDS[1]}"))
  }
  complete -F _godot_completions godot godot-run
fi

# Pi camera commands (WSL only - downloads to Windows)
if [[ "$DOTFILES_OS" == "wsl" ]]; then
  pi-photo() {
    echo "Taking photo..."
    ssh clay@192.168.1.135 "cd ~/camera && source venv/bin/activate && python take_photo.py 2>/dev/null"
    latest=$(ssh clay@192.168.1.135 "ls -t ~/photos/photo_*.jpg 2>/dev/null | head -1")
    scp -q clay@192.168.1.135:"$latest" /mnt/c/Users/clayb/Downloads/
    filename=$(basename "$latest")
    echo "Downloaded: $filename"
  }

  pi-video() {
    duration=${1:-10}
    echo "Recording ${duration}s video..."
    ssh clay@192.168.1.135 "ffmpeg -loglevel error -f v4l2 -framerate 15 -video_size 1280x720 -i /dev/video0 -t $duration -c:v libx264 -preset ultrafast ~/videos/video_\$(date +%Y%m%d_%H%M%S).mp4 2>/dev/null"
    latest=$(ssh clay@192.168.1.135 "ls -t ~/videos/video_*.mp4 2>/dev/null | head -1")
    scp -q clay@192.168.1.135:"$latest" /mnt/c/Users/clayb/Downloads/
    filename=$(basename "$latest")
    echo "Downloaded: $filename"
  }
fi
