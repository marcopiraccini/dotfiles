#!/bin/bash

# Dependency checker for dotfiles
# Verifies that all required tools and configurations are properly installed

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Counters
MISSING=0
INSTALLED=0
WARNINGS=0

echo -e "${BLUE}=====================================${NC}"
echo -e "${BLUE}  Dotfiles Dependency Checker${NC}"
echo -e "${BLUE}=====================================${NC}"
echo ""

# Function to check if command exists
check_command() {
    local cmd=$1
    local name=$2
    local optional=$3
    local version_cmd=${4:-"--version"}

    if command -v "$cmd" &> /dev/null; then
        local version=$($cmd $version_cmd 2>&1 | head -n 1 || echo "installed")
        echo -e "${GREEN}✓${NC} $name: ${version}"
        ((INSTALLED++))
        return 0
    else
        if [ "$optional" = "true" ]; then
            echo -e "${YELLOW}⚠${NC} $name: not installed (optional)"
            ((WARNINGS++))
        else
            echo -e "${RED}✗${NC} $name: not installed"
            ((MISSING++))
        fi
        return 1
    fi
}

# Function to check if directory/file exists
check_path() {
    local path=$1
    local name=$2
    local optional=$3

    if [ -e "$path" ]; then
        echo -e "${GREEN}✓${NC} $name: found at $path"
        ((INSTALLED++))
        return 0
    else
        if [ "$optional" = "true" ]; then
            echo -e "${YELLOW}⚠${NC} $name: not found (optional)"
            ((WARNINGS++))
        else
            echo -e "${RED}✗${NC} $name: not found at $path"
            ((MISSING++))
        fi
        return 1
    fi
}

echo -e "${BLUE}Checking core dependencies...${NC}"
check_command "zsh" "Zsh"
check_command "git" "Git"
check_command "rsync" "Rsync"

echo ""
echo -e "${BLUE}Checking shell framework...${NC}"
check_path "$HOME/.oh-my-zsh" "oh-my-zsh"

if [ -d "$HOME/.oh-my-zsh/custom/themes/spaceship-prompt" ] || [ -d "$HOME/.oh-my-zsh/custom/themes/spaceship.zsh-theme" ]; then
    echo -e "${GREEN}✓${NC} Spaceship theme: installed"
    ((INSTALLED++))
else
    echo -e "${YELLOW}⚠${NC} Spaceship theme: not found (run: git clone https://github.com/spaceship-prompt/spaceship-prompt.git \"\$ZSH_CUSTOM/themes/spaceship-prompt\" --depth=1)"
    ((WARNINGS++))
fi

echo ""
echo -e "${BLUE}Checking editor...${NC}"
check_command "nvim" "Neovim"
check_path "$HOME/.config/nvim" "Neovim config" "true"

echo ""
echo -e "${BLUE}Checking terminal...${NC}"
check_command "kitty" "Kitty terminal" "true"
check_command "ghostty" "Ghostty terminal" "true"

echo ""
echo -e "${BLUE}Checking search and file tools...${NC}"
check_command "rg" "ripgrep"
check_command "fd" "fd-find" "true"
check_command "fzf" "fzf" "true"

echo ""
echo -e "${BLUE}Checking system monitoring tools...${NC}"
check_command "gdu" "gdu" "true"
check_command "btm" "bottom" "true"

echo ""
echo -e "${BLUE}Checking Node.js ecosystem...${NC}"
check_path "$HOME/.nvm" "nvm"

if [ -s "$HOME/.nvm/nvm.sh" ]; then
    # Source nvm to check node
    source "$HOME/.nvm/nvm.sh"
    check_command "node" "Node.js" "true"
else
    echo -e "${YELLOW}⚠${NC} Node.js: cannot check (nvm not loaded)"
    ((WARNINGS++))
fi

check_command "pnpm" "pnpm" "true"
check_command "npm" "npm" "true"

echo ""
echo -e "${BLUE}Checking Go environment...${NC}"
check_command "go" "Go" "true" "version"

if [ -n "$GOPATH" ]; then
    echo -e "${GREEN}✓${NC} GOPATH: $GOPATH"
    ((INSTALLED++))
else
    echo -e "${YELLOW}⚠${NC} GOPATH: not set"
    ((WARNINGS++))
fi

echo ""
echo -e "${BLUE}Checking Rust environment...${NC}"
check_command "rustc" "Rust compiler" "true"
check_command "cargo" "Cargo" "true"
check_command "rust-analyzer" "rust-analyzer" "true"

echo ""
echo -e "${BLUE}Checking other development tools...${NC}"
check_command "docker" "Docker" "true"
check_command "kubectl" "kubectl" "true" "version --client"
check_command "gh" "GitHub CLI" "true"

echo ""
echo -e "${BLUE}Checking Claude Code...${NC}"
check_path "$HOME/.claude" "Claude config directory" "true"
check_path "$HOME/.claude/CLAUDE.md" "Claude global config" "true"

echo ""
echo -e "${BLUE}=====================================${NC}"
echo -e "${BLUE}  Summary${NC}"
echo -e "${BLUE}=====================================${NC}"
echo -e "${GREEN}Installed:${NC} $INSTALLED"
echo -e "${YELLOW}Warnings:${NC} $WARNINGS (optional components)"
echo -e "${RED}Missing:${NC} $MISSING (required components)"
echo ""

if [ $MISSING -eq 0 ]; then
    echo -e "${GREEN}✓ All required dependencies are installed!${NC}"
    if [ $WARNINGS -gt 0 ]; then
        echo -e "${YELLOW}  Some optional components are missing, but your setup should work.${NC}"
    fi
    exit 0
else
    echo -e "${RED}✗ Some required dependencies are missing.${NC}"
    echo -e "  Please install the missing components before running setup.sh"
    exit 1
fi
