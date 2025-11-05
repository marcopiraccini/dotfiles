#!/bin/bash

# Install FiraCode Nerd Font - latest version
# Automatically fetches the latest release from GitHub

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}=====================================${NC}"
echo -e "${BLUE}  FiraCode Nerd Font Installer${NC}"
echo -e "${BLUE}=====================================${NC}"
echo ""

# Check if required tools are installed
if ! command -v wget &> /dev/null && ! command -v curl &> /dev/null; then
    echo -e "${RED}✗ Neither wget nor curl is installed!${NC}"
    echo "Please install one of them:"
    echo "  sudo apt install wget"
    echo "  sudo apt install curl"
    exit 1
fi

if ! command -v unzip &> /dev/null; then
    echo -e "${RED}✗ unzip is not installed!${NC}"
    echo "Installing unzip..."
    sudo apt install -y unzip
fi

# Ensure fontconfig is installed
if ! command -v fc-cache &> /dev/null; then
    echo -e "${YELLOW}Installing fontconfig...${NC}"
    sudo apt install -y fontconfig
fi

echo -e "${BLUE}Fetching latest FiraCode Nerd Font release...${NC}"

# Get latest release info from GitHub API
LATEST_RELEASE=$(curl -s https://api.github.com/repos/ryanoasis/nerd-fonts/releases/latest)
LATEST_VERSION=$(echo "$LATEST_RELEASE" | grep '"tag_name":' | sed -E 's/.*"tag_name": "([^"]+)".*/\1/')
DOWNLOAD_URL="https://github.com/ryanoasis/nerd-fonts/releases/download/${LATEST_VERSION}/FiraCode.zip"

if [ -z "$LATEST_VERSION" ]; then
    echo -e "${RED}✗ Failed to fetch latest version${NC}"
    echo -e "${YELLOW}Falling back to known version v3.3.0${NC}"
    LATEST_VERSION="v3.3.0"
    DOWNLOAD_URL="https://github.com/ryanoasis/nerd-fonts/releases/download/v3.3.0/FiraCode.zip"
fi

echo -e "${GREEN}✓ Latest version: ${LATEST_VERSION}${NC}"
echo ""

# Create fonts directory
FONT_DIR="$HOME/.local/share/fonts"
mkdir -p "$FONT_DIR"

# Download FiraCode
echo -e "${BLUE}Downloading FiraCode Nerd Font ${LATEST_VERSION}...${NC}"
cd "$HOME"

if command -v wget &> /dev/null; then
    wget -q --show-progress "$DOWNLOAD_URL" -O FiraCode.zip
else
    curl -L "$DOWNLOAD_URL" -o FiraCode.zip
fi

if [ ! -f "FiraCode.zip" ]; then
    echo -e "${RED}✗ Download failed${NC}"
    exit 1
fi

echo -e "${GREEN}✓ Download complete${NC}"
echo ""

# Extract fonts
echo -e "${BLUE}Extracting fonts to ${FONT_DIR}...${NC}"
unzip -o -q FiraCode.zip -d "$FONT_DIR"

# Remove Windows-specific fonts
echo -e "${BLUE}Cleaning up Windows fonts...${NC}"
cd "$FONT_DIR"
rm -f *Windows* 2>/dev/null || true

# Clean up
cd "$HOME"
rm -f FiraCode.zip

echo -e "${GREEN}✓ Fonts extracted${NC}"
echo ""

# Rebuild font cache
echo -e "${BLUE}Rebuilding font cache...${NC}"
fc-cache -fv > /dev/null 2>&1

echo -e "${GREEN}✓ Font cache rebuilt${NC}"
echo ""

# Verify installation
if fc-list | grep -i "FiraCode Nerd Font" > /dev/null; then
    echo -e "${GREEN}=====================================${NC}"
    echo -e "${GREEN}  Installation Complete!${NC}"
    echo -e "${GREEN}=====================================${NC}"
    echo ""
    echo -e "${GREEN}✓ FiraCode Nerd Font ${LATEST_VERSION} installed successfully${NC}"
    echo ""
    echo "Font location: $FONT_DIR"
    echo ""
    echo "To use in your terminal:"
    echo "  - Kitty: Already configured in kitty.conf"
    echo "  - Ghostty: Already configured in ghostty/config"
    echo "  - Other terminals: Set font to 'FiraCode Nerd Font Mono'"
else
    echo -e "${YELLOW}⚠ Font installed but not detected in cache${NC}"
    echo "You may need to restart your terminal or applications"
fi
