#!/bin/bash

# Install latest Neovim
# Downloads pre-built binary for Linux

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}=====================================${NC}"
echo -e "${BLUE}  Neovim Installer${NC}"
echo -e "${BLUE}=====================================${NC}"
echo ""

# Check if Neovim is already installed
if command -v nvim &> /dev/null; then
    CURRENT_VERSION=$(nvim --version | head -1 || echo "unknown")
    echo -e "${GREEN}✓ Neovim is already installed${NC}"
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

# Map architecture to Neovim's naming scheme
case $ARCH in
    x86_64)
        NVIM_ARCH="linux-x86_64"
        ;;
    aarch64|arm64)
        NVIM_ARCH="linux-arm64"
        echo -e "${GREEN}✓ ARM64 architecture - will use arm64 binary${NC}"
        ;;
    *)
        echo -e "${RED}✗ Unsupported architecture: ${ARCH}${NC}"
        exit 1
        ;;
esac

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

echo -e "${BLUE}Fetching latest Neovim release...${NC}"

# Get latest stable release from GitHub API
LATEST_RELEASE=$(curl -s https://api.github.com/repos/neovim/neovim/releases/latest)
LATEST_VERSION=$(echo "$LATEST_RELEASE" | grep '"tag_name":' | sed -E 's/.*"tag_name": "([^"]+)".*/\1/')

if [ -z "$LATEST_VERSION" ]; then
    echo -e "${RED}✗ Failed to fetch latest release${NC}"
    echo "Please check: https://github.com/neovim/neovim/releases"
    exit 1
fi

echo -e "${GREEN}✓ Latest version: ${LATEST_VERSION}${NC}"
echo ""

# Construct download URL
DOWNLOAD_URL="https://github.com/neovim/neovim/releases/download/${LATEST_VERSION}/nvim-${NVIM_ARCH}.tar.gz"

echo -e "${GREEN}✓ Download URL: $(basename "$DOWNLOAD_URL")${NC}"
echo ""

# Download
echo -e "${BLUE}Downloading Neovim ${LATEST_VERSION}...${NC}"
TMP_DIR=$(mktemp -d)
cd "$TMP_DIR"

if command -v curl &> /dev/null; then
    curl -L "$DOWNLOAD_URL" -o nvim.tar.gz
else
    wget "$DOWNLOAD_URL" -O nvim.tar.gz
fi

if [ ! -f "nvim.tar.gz" ]; then
    echo -e "${RED}✗ Download failed${NC}"
    rm -rf "$TMP_DIR"
    exit 1
fi

echo -e "${GREEN}✓ Download complete${NC}"
echo ""

# Extract
echo -e "${BLUE}Extracting archive...${NC}"
tar -xzf nvim.tar.gz

# The extracted directory is named nvim-linux-x86_64 or nvim-linux-arm64
EXTRACTED_DIR="nvim-${NVIM_ARCH}"

if [ ! -d "$EXTRACTED_DIR" ]; then
    echo -e "${RED}✗ Extraction failed or unexpected directory structure${NC}"
    echo "Looking for: $EXTRACTED_DIR"
    echo "Found:"
    ls -la
    cd "$HOME"
    rm -rf "$TMP_DIR"
    exit 1
fi

echo -e "${GREEN}✓ Extraction complete${NC}"
echo ""

# Install to /opt with architecture-specific name
INSTALL_DIR="/opt/nvim-${NVIM_ARCH}"

echo -e "${BLUE}Installing to ${INSTALL_DIR}...${NC}"

# Remove old installation if exists
if [ -d "$INSTALL_DIR" ]; then
    echo -e "${YELLOW}Removing old installation...${NC}"
    sudo rm -rf "$INSTALL_DIR"
fi

# Move to /opt
sudo mv "$EXTRACTED_DIR" "$INSTALL_DIR"

echo -e "${GREEN}✓ Installed to ${INSTALL_DIR}${NC}"
echo ""

# Create /opt/nvim symlink pointing to the architecture-specific installation
echo -e "${BLUE}Creating /opt/nvim symlink...${NC}"
sudo ln -sf "$INSTALL_DIR" /opt/nvim
echo -e "${GREEN}✓ Symlink created: /opt/nvim -> ${INSTALL_DIR}${NC}"
echo ""

# Create symlink in /usr/local/bin (optional alternative to adding to PATH)
echo -e "${BLUE}Creating /usr/local/bin/nvim symlink...${NC}"
sudo ln -sf "${INSTALL_DIR}/bin/nvim" /usr/local/bin/nvim

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

if command -v nvim &> /dev/null; then
    NVIM_VERSION=$(nvim --version | head -1)
    echo -e "${GREEN}✓ Neovim installed successfully${NC}"
    echo ""
    echo "Version: $NVIM_VERSION"
    echo "Install location: $INSTALL_DIR"
    echo "Symlink: /opt/nvim -> $INSTALL_DIR"
    echo "Binary symlink: /usr/local/bin/nvim"
else
    echo -e "${YELLOW}⚠ Neovim installed but not in PATH${NC}"
    echo "Install location: $INSTALL_DIR"
    echo "Symlink: /opt/nvim -> $INSTALL_DIR"
fi

echo ""
echo -e "${YELLOW}Configuration:${NC}"
echo "Neovim config is already set up at:"
echo "  ~/.config/nvim"
echo ""
echo "The dotfiles include AstroNvim configuration."
echo ""
echo -e "${YELLOW}Next steps:${NC}"
echo "1. Run: nvim"
echo "2. AstroNvim will auto-install plugins on first run"
echo "3. Install language servers with :Mason"
echo ""
echo "To verify:"
echo "  nvim --version"
echo "  which nvim"
