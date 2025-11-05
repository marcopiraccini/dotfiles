# Dotfiles

Personal collection of shell and editor configurations for a consistent development environment across machines.

**Configured for Linux** (Ubuntu/Debian) with the goal of maintaining common configurations that work across different systems.

## Documentation

- **[TERMINALS.md](TERMINALS.md)** - Complete guide to Kitty and Ghostty terminal configurations, keybindings, and troubleshooting

## Features

- **Shell**: Zsh with oh-my-zsh and Spaceship prompt
- **Editor**: Neovim with AstroNvim configuration
- **Terminal**: Kitty and Ghostty terminal configurations (see [TERMINALS.md](TERMINALS.md))
- **Claude Code**: Pre-configured `.claude` settings with custom commands
- **Git**: Comprehensive aliases and shortcuts
- **Development**: Node.js (nvm), pnpm, Go, Rust, and more

## Prerequisites

Before running the setup, ensure you have these installed:

- **Git**: For cloning the repository
- **Zsh**: The Z shell (`sudo apt install zsh` on Ubuntu/Debian)
- **rsync**: For syncing dotfiles (usually pre-installed on Linux)

**Note**: oh-my-zsh and plugins can be installed automatically using the provided script (see Setup step 2)

## Setup

1. Clone this repository:
```bash
git clone https://github.com/marcopiraccini/dotfiles.git ~/dotfiles
cd ~/dotfiles
```

2. Install oh-my-zsh, Spaceship theme, and plugins:
```bash
./bin/install-zsh-tools.sh
```

This script will automatically install:
- oh-my-zsh framework
- Spaceship prompt theme
- zsh-autosuggestions plugin
- zsh-vi-mode plugin

3. (Optional) Check your system for required dependencies:
```bash
./bin/check-dependencies.sh
```

This script will verify that all required tools are installed and report any missing components.

4. Run the setup script:
```bash
./setup.sh
```

Or force installation without prompt:
```bash
./setup.sh --force
```

This will sync all dotfiles to your home directory, including:
- Shell configuration (`.zshrc`, `.aliases`)
- Editor configs (`.config/nvim`)
- Terminal configs (`.config/kitty`, `.config/ghostty`)
- Claude Code settings (`.claude/`)
- Utility scripts (`bin/`)

## Post-Installation

### Install SSH Keys

Manually copy your `.ssh` folder to the home directory:
```bash
cp -r /path/to/backup/.ssh ~/
chmod 700 ~/.ssh
chmod 600 ~/.ssh/*
```

### Install Neovim

Download and install the latest Neovim:
```bash
# Update the path in .zshrc if using a different location
export PATH=/opt/nvim-linux-x86_64/bin:$PATH
```

Visit [Neovim releases](https://github.com/neovim/neovim/releases) for installation instructions.

### Install AstroNvim

Follow the [AstroNvim installation guide](https://docs.astronvim.com/#-installation):
```bash
git clone --depth 1 https://github.com/AstroNvim/template ~/.config/nvim
nvim
```

### Install Terminal Emulators

#### Kitty
```bash
# Use the provided installation script (official installer or APT):
./bin/install-kitty.sh

# Or install manually via APT:
# sudo apt install kitty
```

#### Ghostty
```bash
# Use the provided installation script (auto-detects architecture):
./bin/install-ghostty.sh

# Or download manually from:
# https://ghostty.org/download
```

Both terminals are configured with Dracula theme, FiraCode Nerd Font, and equivalent keybindings.

**📖 For detailed keybindings, troubleshooting, and feature comparison, see [TERMINALS.md](TERMINALS.md)**

### Install Rust

Use the provided installation script:
```bash
./bin/install-rust.sh
```

This will install:
- Rust toolchain via rustup
- rust-analyzer for IDE support
- All necessary build tools

### Install Essential Utilities

For AstroNvim search and system monitoring to work properly:

```bash
# Search tools
sudo apt install ripgrep fd-find

# System monitoring
sudo apt install gdu

# Install bottom (modern system monitor)
# Visit: https://github.com/ClementTsang/bottom?tab=readme-ov-file#debian--ubuntu
```

### Install Node.js (via NVM)

Use the provided installation script:
```bash
./bin/install-nvm.sh
```

Then install Node.js and tools:
```bash
# Install Node.js LTS
nvm install --lts

# Install pnpm (configured in .zshrc PATH)
npm install -g pnpm
```

## Claude Code Configuration

This dotfiles repo includes `.claude/` configuration:

- **CLAUDE.md**: Global instructions for Claude Code across all projects
- **settings.json**: Permissions and preferences
- **commands/**: Custom slash commands
  - `/catchup` - Review all changed files in current git branch
  - `/pr` - Prepare and create pull requests

## Utility Scripts

The `bin/` directory contains helpful scripts:

### Setup & Installation
- **install-zsh-tools.sh**: Installs oh-my-zsh, Spaceship theme, and zsh plugins (autosuggestions, vi-mode)
- **install-fonts.sh**: Installs FiraCode Nerd Font (automatically fetches latest version)
- **install-kitty.sh**: Installs Kitty terminal (official installer or APT)
- **install-ghostty.sh**: Installs Ghostty terminal (auto-detects correct architecture)
- **install-nvm.sh**: Installs NVM (Node Version Manager) for managing Node.js versions
- **install-rust.sh**: Installs Rust toolchain via rustup, including rust-analyzer

### Utilities
- **check-dependencies.sh**: Verifies all required and optional dependencies are installed
- **reset-nvim.sh**: Resets Neovim configuration to defaults
- **settuning.sh**: System tuning configurations

These scripts are automatically added to your PATH when the dotfiles are installed.

## Customization

### Machine-Specific Settings

For machine-specific configurations that shouldn't be synced:

1. Create a `.zshrc.local` file in your home directory
2. Add machine-specific environment variables and settings
3. It will be automatically sourced by `.zshrc`

### Modifying Paths

Update these paths in `.zshrc` based on your setup:
- `GOPATH` (line 144)
- `PNPM_HOME` (line 138)
- Neovim path (line 148)

## Useful Aliases

### Git
- `gs` - git status
- `gpom` - git pull origin master
- `groot` - cd to git root directory
- `uncommit` - undo last commit (keep changes)
- `gl1` - show commits between HEAD and default branch

### Navigation
- `v` or `vim` - open neovim
- `c` - clear terminal
- `q` - exit shell

## License

MIT License - See [LICENSE](LICENSE) file for details.
