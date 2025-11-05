#!/bin/bash

# Install oh-my-zsh, spaceship theme, and plugins
# This script sets up the complete zsh environment

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}=====================================${NC}"
echo -e "${BLUE}  Zsh Tools Installer${NC}"
echo -e "${BLUE}=====================================${NC}"
echo ""

# Check if zsh is installed
if ! command -v zsh &> /dev/null; then
    echo -e "${RED}✗ Zsh is not installed!${NC}"
    echo "Please install zsh first:"
    echo "  Ubuntu/Debian: sudo apt install zsh"
    echo "  Fedora: sudo dnf install zsh"
    echo "  macOS: brew install zsh"
    exit 1
fi

echo -e "${GREEN}✓ Zsh is installed${NC}"
echo ""

# Install oh-my-zsh
echo -e "${BLUE}Installing oh-my-zsh...${NC}"
if [ -d "$HOME/.oh-my-zsh" ]; then
    echo -e "${YELLOW}⚠ oh-my-zsh is already installed${NC}"
    read -p "Do you want to reinstall it? (y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        echo -e "${YELLOW}Removing existing oh-my-zsh...${NC}"
        rm -rf "$HOME/.oh-my-zsh"
    else
        echo -e "${BLUE}Skipping oh-my-zsh installation${NC}"
    fi
fi

if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo -e "${BLUE}Downloading and installing oh-my-zsh...${NC}"
    RUNZSH=no KEEP_ZSHRC=yes sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    echo -e "${GREEN}✓ oh-my-zsh installed${NC}"
else
    echo -e "${GREEN}✓ oh-my-zsh already installed${NC}"
fi
echo ""

# Install Spaceship theme
echo -e "${BLUE}Installing Spaceship theme...${NC}"
SPACESHIP_DIR="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/spaceship-prompt"

if [ -d "$SPACESHIP_DIR" ]; then
    echo -e "${YELLOW}⚠ Spaceship theme is already installed${NC}"
    read -p "Do you want to update it? (y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        echo -e "${BLUE}Updating Spaceship theme...${NC}"
        cd "$SPACESHIP_DIR"
        git pull
        cd - > /dev/null
        echo -e "${GREEN}✓ Spaceship theme updated${NC}"
    else
        echo -e "${BLUE}Skipping Spaceship update${NC}"
    fi
else
    echo -e "${BLUE}Downloading Spaceship theme...${NC}"
    git clone https://github.com/spaceship-prompt/spaceship-prompt.git "$SPACESHIP_DIR" --depth=1
    echo -e "${GREEN}✓ Spaceship theme installed${NC}"
fi

# Create symlink if it doesn't exist
SPACESHIP_LINK="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/spaceship.zsh-theme"
if [ ! -L "$SPACESHIP_LINK" ]; then
    ln -s "$SPACESHIP_DIR/spaceship.zsh-theme" "$SPACESHIP_LINK"
    echo -e "${GREEN}✓ Spaceship theme linked${NC}"
fi
echo ""

# Install zsh-autosuggestions
echo -e "${BLUE}Installing zsh-autosuggestions plugin...${NC}"
AUTOSUGGESTIONS_DIR="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions"

if [ -d "$AUTOSUGGESTIONS_DIR" ]; then
    echo -e "${YELLOW}⚠ zsh-autosuggestions is already installed${NC}"
    read -p "Do you want to update it? (y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        echo -e "${BLUE}Updating zsh-autosuggestions...${NC}"
        cd "$AUTOSUGGESTIONS_DIR"
        git pull
        cd - > /dev/null
        echo -e "${GREEN}✓ zsh-autosuggestions updated${NC}"
    else
        echo -e "${BLUE}Skipping zsh-autosuggestions update${NC}"
    fi
else
    echo -e "${BLUE}Downloading zsh-autosuggestions...${NC}"
    git clone https://github.com/zsh-users/zsh-autosuggestions "$AUTOSUGGESTIONS_DIR"
    echo -e "${GREEN}✓ zsh-autosuggestions installed${NC}"
fi
echo ""

# Install zsh-vi-mode
echo -e "${BLUE}Installing zsh-vi-mode plugin...${NC}"
VIMODE_DIR="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-vi-mode"

if [ -d "$VIMODE_DIR" ]; then
    echo -e "${YELLOW}⚠ zsh-vi-mode is already installed${NC}"
    read -p "Do you want to update it? (y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        echo -e "${BLUE}Updating zsh-vi-mode...${NC}"
        cd "$VIMODE_DIR"
        git pull
        cd - > /dev/null
        echo -e "${GREEN}✓ zsh-vi-mode updated${NC}"
    else
        echo -e "${BLUE}Skipping zsh-vi-mode update${NC}"
    fi
else
    echo -e "${BLUE}Downloading zsh-vi-mode...${NC}"
    git clone https://github.com/jeffreytse/zsh-vi-mode "$VIMODE_DIR"
    echo -e "${GREEN}✓ zsh-vi-mode installed${NC}"
fi
echo ""

# Summary
echo -e "${BLUE}=====================================${NC}"
echo -e "${BLUE}  Installation Complete!${NC}"
echo -e "${BLUE}=====================================${NC}"
echo ""
echo -e "${GREEN}✓ oh-my-zsh${NC}"
echo -e "${GREEN}✓ Spaceship theme${NC}"
echo -e "${GREEN}✓ zsh-autosuggestions plugin${NC}"
echo -e "${GREEN}✓ zsh-vi-mode plugin${NC}"
echo ""
echo -e "${YELLOW}Next steps:${NC}"
echo "1. Make sure your .zshrc includes these plugins in the plugins array:"
echo "   plugins=(... zsh-autosuggestions zsh-vi-mode ...)"
echo ""
echo "2. Make sure your .zshrc sets the theme:"
echo "   ZSH_THEME=\"spaceship\""
echo ""
echo "3. Restart your shell or run: source ~/.zshrc"
echo ""
echo -e "${GREEN}Enjoy your enhanced Zsh experience!${NC}"
