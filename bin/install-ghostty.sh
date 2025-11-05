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

if ! command -v tar &> /dev/null; then
    echo -e "${YELLOW}Installing tar...${NC}"
    sudo apt install -y tar
fi

echo -e "${BLUE}Fetching latest Ghostty release...${NC}"

# Get latest release info from GitHub API
LATEST_RELEASE=$(curl -s https://api.github.com/repos/ghostty-org/ghostty/releases/latest)
LATEST_VERSION=$(echo "$LATEST_RELEASE" | grep '"tag_name":' | sed -E 's/.*"tag_name": "([^"]+)".*/\1/')

if [ -z "$LATEST_VERSION" ]; then
    echo -e "${RED}✗ Failed to fetch latest release${NC}"
    echo "Please check: https://ghostty.org/download"
    exit 1
fi

echo -e "${GREEN}✓ Latest version: ${LATEST_VERSION}${NC}"
echo ""

# Look for the correct binary for this architecture
# Common patterns: ghostty-linux-x86_64.tar.gz, ghostty-${VERSION}-linux-x86_64.tar.gz
ASSETS=$(echo "$LATEST_RELEASE" | grep -o '"browser_download_url": "[^"]*"' | grep -o 'https://[^"]*')

# Try to find matching architecture
DOWNLOAD_URL=$(echo "$ASSETS" | grep -i "linux" | grep -i "${GHOSTTY_ARCH}" | grep -E '\.(tar\.gz|tgz)$' | head -n 1)

if [ -z "$DOWNLOAD_URL" ]; then
    # Try alternative pattern without explicit "linux" in filename
    DOWNLOAD_URL=$(echo "$ASSETS" | grep "${GHOSTTY_ARCH}" | grep -E '\.(tar\.gz|tgz)$' | head -n 1)
fi

if [ -z "$DOWNLOAD_URL" ]; then
    echo -e "${RED}✗ No pre-built binary found for ${GHOSTTY_ARCH}${NC}"
    echo ""
    echo "Available assets for this release:"
    echo "$ASSETS" | while read url; do
        echo "  - $(basename "$url")"
    done
    echo ""
    echo "Please visit: https://ghostty.org/download"
    echo "Or check: https://github.com/ghostty-org/ghostty/releases/latest"
    exit 1
fi

echo -e "${GREEN}✓ Found binary: $(basename "$DOWNLOAD_URL")${NC}"
echo ""

# Download
echo -e "${BLUE}Downloading Ghostty ${LATEST_VERSION}...${NC}"
TMP_DIR=$(mktemp -d)
cd "$TMP_DIR"

if command -v curl &> /dev/null; then
    curl -L "$DOWNLOAD_URL" -o ghostty.tar.gz
else
    wget "$DOWNLOAD_URL" -O ghostty.tar.gz
fi

if [ ! -f "ghostty.tar.gz" ]; then
    echo -e "${RED}✗ Download failed${NC}"
    rm -rf "$TMP_DIR"
    exit 1
fi

echo -e "${GREEN}✓ Download complete${NC}"
echo ""

# Extract
echo -e "${BLUE}Extracting archive...${NC}"
tar -xzf ghostty.tar.gz

# Find the ghostty binary (it might be in a subdirectory)
GHOSTTY_BIN=$(find . -name "ghostty" -type f -executable | head -n 1)

if [ -z "$GHOSTTY_BIN" ]; then
    echo -e "${RED}✗ Could not find ghostty binary in archive${NC}"
    echo "Archive contents:"
    tar -tzf ghostty.tar.gz | head -20
    cd "$HOME"
    rm -rf "$TMP_DIR"
    exit 1
fi

echo -e "${GREEN}✓ Found binary: ${GHOSTTY_BIN}${NC}"
echo ""

# Install
echo -e "${BLUE}Installing to ~/.local/bin...${NC}"
mkdir -p "$HOME/.local/bin"
cp "$GHOSTTY_BIN" "$HOME/.local/bin/ghostty"
chmod +x "$HOME/.local/bin/ghostty"

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
    echo -e "${GREEN}✓ Ghostty ${GHOSTTY_VERSION}${NC}"
    echo "Installed to: $HOME/.local/bin/ghostty"
else
    echo -e "${YELLOW}⚠ Ghostty installed but not in PATH${NC}"
    echo "Installed to: $HOME/.local/bin/ghostty"
    echo ""
    echo "Add to PATH (already in .zshrc):"
    echo "  export PATH=\$HOME/.local/bin:\$PATH"
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
echo ""
echo -e "${BLUE}Note: You may need to restart your terminal for PATH changes to take effect${NC}"
