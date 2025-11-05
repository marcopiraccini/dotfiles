#!/bin/bash

# Install NVM (Node Version Manager)
# Automatically fetches the latest release from GitHub

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}=====================================${NC}"
echo -e "${BLUE}  NVM Installer${NC}"
echo -e "${BLUE}=====================================${NC}"
echo ""

# Check if required tools are installed
if ! command -v curl &> /dev/null && ! command -v wget &> /dev/null; then
    echo -e "${RED}✗ Neither curl nor wget is installed!${NC}"
    echo "Please install one of them:"
    echo "  sudo apt install curl"
    echo "  sudo apt install wget"
    exit 1
fi

# Check if nvm is already installed
if [ -d "$HOME/.nvm" ]; then
    echo -e "${YELLOW}⚠ NVM is already installed at $HOME/.nvm${NC}"
    read -p "Do you want to reinstall it? (y/n) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo -e "${BLUE}Skipping installation${NC}"

        # Load nvm and show version
        export NVM_DIR="$HOME/.nvm"
        [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

        if command -v nvm &> /dev/null; then
            echo -e "${GREEN}✓ Current NVM version: $(nvm --version)${NC}"
        fi
        exit 0
    else
        echo -e "${YELLOW}Removing existing NVM installation...${NC}"
        rm -rf "$HOME/.nvm"
    fi
fi

echo -e "${BLUE}Fetching latest NVM release...${NC}"

# Get latest release version from GitHub API
LATEST_RELEASE=$(curl -s https://api.github.com/repos/nvm-sh/nvm/releases/latest)
LATEST_VERSION=$(echo "$LATEST_RELEASE" | grep '"tag_name":' | sed -E 's/.*"tag_name": "([^"]+)".*/\1/')

if [ -z "$LATEST_VERSION" ]; then
    echo -e "${RED}✗ Failed to fetch latest version${NC}"
    echo -e "${YELLOW}Falling back to known version v0.39.7${NC}"
    LATEST_VERSION="v0.39.7"
fi

echo -e "${GREEN}✓ Latest version: ${LATEST_VERSION}${NC}"
echo ""

# Download and install NVM
echo -e "${BLUE}Downloading and installing NVM ${LATEST_VERSION}...${NC}"

INSTALL_URL="https://raw.githubusercontent.com/nvm-sh/nvm/${LATEST_VERSION}/install.sh"

if command -v curl &> /dev/null; then
    curl -o- "$INSTALL_URL" | bash
else
    wget -qO- "$INSTALL_URL" | bash
fi

if [ $? -ne 0 ]; then
    echo -e "${RED}✗ Installation failed${NC}"
    exit 1
fi

echo ""
echo -e "${GREEN}✓ NVM installed successfully${NC}"
echo ""

# Load nvm for current session
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

# Verify installation
if command -v nvm &> /dev/null; then
    NVM_VERSION=$(nvm --version)
    echo -e "${GREEN}=====================================${NC}"
    echo -e "${GREEN}  Installation Complete!${NC}"
    echo -e "${GREEN}=====================================${NC}"
    echo ""
    echo -e "${GREEN}✓ NVM ${NVM_VERSION} installed successfully${NC}"
    echo ""
    echo "Installation directory: $NVM_DIR"
    echo ""
    echo -e "${YELLOW}Next steps:${NC}"
    echo "1. Restart your terminal or run:"
    echo "   source ~/.zshrc"
    echo ""
    echo "2. Install Node.js LTS:"
    echo "   nvm install --lts"
    echo ""
    echo "3. Install Node.js latest:"
    echo "   nvm install node"
    echo ""
    echo "4. List available versions:"
    echo "   nvm ls-remote"
    echo ""
    echo "5. Switch between versions:"
    echo "   nvm use <version>"
else
    echo -e "${YELLOW}⚠ NVM installed but not available in current session${NC}"
    echo "Please restart your terminal or run: source ~/.zshrc"
fi
