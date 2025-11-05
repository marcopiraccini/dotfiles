#!/bin/bash

# Install Ghostty terminal emulator
# Downloads pre-built binary for the correct architecture

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}=====================================${NC}"
echo -e "${BLUE}  Ghostty Terminal Installer${NC}"
echo -e "${BLUE}=====================================${NC}"
echo ""

# Check if Ghostty is already installed
if command -v ghostty &> /dev/null; then
    CURRENT_VERSION=$(ghostty --version 2>/dev/null || echo "unknown")
    echo -e "${GREEN}✓ Ghostty is already installed${NC}"
    echo "Version: $CURRENT_VERSION"
    echo ""
    read -p "Do you want to reinstall/update it? (y/n) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo -e "${BLUE}Installation cancelled${NC}"
        exit 0
    fi
fi

# Detect architecture
ARCH=$(uname -m)
echo -e "${BLUE}Detected architecture: ${ARCH}${NC}"

# Map architecture to Ghostty release naming
case $ARCH in
    x86_64)
        GHOSTTY_ARCH="x86_64"
        ;;
    aarch64|arm64)
        GHOSTTY_ARCH="aarch64"
        ;;
    *)
        echo -e "${RED}✗ Unsupported architecture: ${ARCH}${NC}"
        echo "Ghostty pre-built binaries are typically available for x86_64 and aarch64"
        exit 1
        ;;
esac

echo -e "${GREEN}✓ Will download for: ${GHOSTTY_ARCH}${NC}"
echo ""

# Check for required tools
if ! command -v curl &> /dev/null && ! command -v wget &> /dev/null; then
    echo -e "${RED}✗ Neither curl nor wget is installed!${NC}"
    echo "Please install one of them:"
    echo "  sudo apt install curl"
    exit 1
fi

# dpkg should be available on Debian/Ubuntu systems
if ! command -v dpkg &> /dev/null; then
    echo -e "${RED}✗ dpkg is not available${NC}"
    echo "This script is designed for Debian/Ubuntu systems"
    exit 1
fi

echo -e "${BLUE}Fetching Ghostty release...${NC}"

# Use ghostty-ubuntu repo which provides pre-built Linux binaries
REPO="mkasberg/ghostty-ubuntu"
LATEST_RELEASE=$(curl -s https://api.github.com/repos/${REPO}/releases/latest)
LATEST_VERSION=$(echo "$LATEST_RELEASE" | grep '"tag_name":' | sed -E 's/.*"tag_name": "([^"]+)".*/\1/')

if [ -z "$LATEST_VERSION" ]; then
    echo -e "${RED}✗ Failed to fetch releases${NC}"
    echo "Please check: https://github.com/${REPO}/releases"
    exit 1
fi

echo -e "${GREEN}✓ Found release: ${LATEST_VERSION}${NC}"
echo ""

# Look for .deb package for this architecture
ASSETS=$(echo "$LATEST_RELEASE" | grep -o '"browser_download_url": "[^"]*"' | grep -o 'https://[^"]*')

# Find .deb package matching architecture
# Debian package naming: ghostty_1.2.3_amd64.deb or similar
case $GHOSTTY_ARCH in
    x86_64)
        DEB_ARCH="amd64"
        ;;
    aarch64)
        DEB_ARCH="arm64"
        ;;
esac

DOWNLOAD_URL=$(echo "$ASSETS" | grep "\.deb$" | grep -i "${DEB_ARCH}" | head -n 1)

if [ -z "$DOWNLOAD_URL" ]; then
    echo -e "${RED}✗ No .deb package found for ${DEB_ARCH}${NC}"
    echo ""
    echo "Available packages for this release:"
    echo "$ASSETS" | while read url; do
        echo "  - $(basename "$url")"
    done
    echo ""
    echo "Please check: https://github.com/${REPO}/releases"
    exit 1
fi

echo -e "${GREEN}✓ Found package: $(basename "$DOWNLOAD_URL")${NC}"
echo ""

# Download
echo -e "${BLUE}Downloading Ghostty ${LATEST_VERSION}...${NC}"
TMP_DIR=$(mktemp -d)
cd "$TMP_DIR"

if command -v curl &> /dev/null; then
    curl -L "$DOWNLOAD_URL" -o ghostty.deb
else
    wget "$DOWNLOAD_URL" -O ghostty.deb
fi

if [ ! -f "ghostty.deb" ]; then
    echo -e "${RED}✗ Download failed${NC}"
    rm -rf "$TMP_DIR"
    exit 1
fi

echo -e "${GREEN}✓ Download complete${NC}"
echo ""

# Install with dpkg
echo -e "${BLUE}Installing .deb package...${NC}"
sudo dpkg -i ghostty.deb

# Fix any missing dependencies
if [ $? -ne 0 ]; then
    echo -e "${YELLOW}Fixing missing dependencies...${NC}"
    sudo apt-get install -f -y
fi

# Clean up
cd "$HOME"
rm -rf "$TMP_DIR"

echo -e "${GREEN}✓ Installation complete${NC}"
echo ""

# Verify installation
echo -e "${GREEN}=====================================${NC}"
echo -e "${GREEN}  Installation Complete!${NC}"
echo -e "${GREEN}=====================================${NC}"
echo ""

if command -v ghostty &> /dev/null; then
    GHOSTTY_VERSION=$(ghostty --version 2>/dev/null || echo "installed")
    echo -e "${GREEN}✓ Ghostty installed successfully${NC}"
    echo ""
    echo "Version info:"
    ghostty --version 2>/dev/null | head -10 || echo "  $(ghostty --version 2>&1 | head -1)"
else
    echo -e "${YELLOW}⚠ Ghostty installed but not in PATH${NC}"
    echo "You may need to restart your terminal"
fi

echo ""
echo -e "${YELLOW}Configuration:${NC}"
echo "Ghostty config is already set up at:"
echo "  ~/.config/ghostty/config"
echo ""
echo "The configuration includes:"
echo "  - Dracula color theme"
echo "  - FiraCode Nerd Font"
echo "  - Keybindings matching Kitty"
echo ""
echo "To run Ghostty:"
echo "  ghostty"
