#!/bin/bash

# Install Kitty terminal emulator
# Uses official installer script

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}=====================================${NC}"
echo -e "${BLUE}  Kitty Terminal Installer${NC}"
echo -e "${BLUE}=====================================${NC}"
echo ""

# Check if Kitty is already installed
if command -v kitty &> /dev/null; then
    CURRENT_VERSION=$(kitty --version 2>/dev/null | head -1 || echo "unknown")
    echo -e "${GREEN}✓ Kitty is already installed${NC}"
    echo "Version: $CURRENT_VERSION"
    echo ""
    read -p "Do you want to reinstall/update it? (y/n) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo -e "${BLUE}Installation cancelled${NC}"
        exit 0
    fi
fi

echo -e "${YELLOW}Select installation method:${NC}"
echo "1) Official installer (recommended - installs to ~/.local)"
echo "2) APT package manager (Ubuntu/Debian repos)"
echo "3) Cancel"
echo ""
read -p "Enter choice [1-3]: " -n 1 -r
echo ""

case $REPLY in
    1)
        echo -e "${BLUE}=====================================${NC}"
        echo -e "${BLUE}  Installing via Official Installer${NC}"
        echo -e "${BLUE}=====================================${NC}"
        echo ""

        # Check for required tools
        if ! command -v curl &> /dev/null; then
            echo -e "${YELLOW}Installing curl...${NC}"
            sudo apt install -y curl
        fi

        echo -e "${BLUE}Downloading and running official Kitty installer...${NC}"
        echo ""

        # Download and run the official installer
        curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin

        if [ $? -ne 0 ]; then
            echo -e "${RED}✗ Installation failed${NC}"
            exit 1
        fi

        echo ""
        echo -e "${GREEN}✓ Kitty installed successfully${NC}"
        echo ""

        # Create symbolic links
        echo -e "${BLUE}Creating desktop integration...${NC}"

        # Ensure directories exist
        mkdir -p ~/.local/bin
        mkdir -p ~/.local/share/applications

        # Create symlinks if they don't exist
        if [ ! -e "$HOME/.local/bin/kitty" ]; then
            ln -sf ~/.local/kitty.app/bin/kitty ~/.local/bin/
        fi

        # Create desktop file
        if [ ! -e "$HOME/.local/share/applications/kitty.desktop" ]; then
            cp ~/.local/kitty.app/share/applications/kitty.desktop ~/.local/share/applications/ 2>/dev/null || true
        fi

        # Update desktop database
        if command -v update-desktop-database &> /dev/null; then
            update-desktop-database ~/.local/share/applications/ 2>/dev/null || true
        fi

        echo -e "${GREEN}✓ Desktop integration complete${NC}"
        ;;

    2)
        echo -e "${BLUE}=====================================${NC}"
        echo -e "${BLUE}  Installing via APT${NC}"
        echo -e "${BLUE}=====================================${NC}"
        echo ""

        echo -e "${BLUE}Installing Kitty from Ubuntu/Debian repositories...${NC}"
        sudo apt update
        sudo apt install -y kitty

        if [ $? -ne 0 ]; then
            echo -e "${RED}✗ Installation failed${NC}"
            exit 1
        fi

        echo -e "${GREEN}✓ Kitty installed successfully${NC}"
        ;;

    3|*)
        echo -e "${BLUE}Installation cancelled${NC}"
        exit 0
        ;;
esac

echo ""
echo -e "${GREEN}=====================================${NC}"
echo -e "${GREEN}  Installation Complete!${NC}"
echo -e "${GREEN}=====================================${NC}"
echo ""

# Verify installation
if command -v kitty &> /dev/null; then
    KITTY_VERSION=$(kitty --version 2>/dev/null | head -1 || echo "installed")
    echo -e "${GREEN}✓ Kitty installed successfully${NC}"
    echo ""
    echo "Version: $KITTY_VERSION"
else
    echo -e "${YELLOW}⚠ Kitty installed but not in PATH${NC}"
    echo "You may need to restart your terminal"
fi

echo ""
echo -e "${YELLOW}Configuration:${NC}"
echo "Kitty config is already set up at:"
echo "  ~/.config/kitty/kitty.conf"
echo ""
echo "The configuration includes:"
echo "  - Dracula color theme"
echo "  - FiraCode Nerd Font"
echo "  - Custom keybindings"
echo "  - Split layouts enabled"
echo ""
echo "To run Kitty:"
echo "  kitty"
echo ""
echo -e "${BLUE}Note: You may need to log out and back in for desktop integration to work${NC}"
