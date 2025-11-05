#!/bin/bash

# Install Claude Code CLI
# Uses the official Claude Code installer

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}=====================================${NC}"
echo -e "${BLUE}  Claude Code CLI Installer${NC}"
echo -e "${BLUE}=====================================${NC}"
echo ""

# Check if Claude Code is already installed
if command -v claude &> /dev/null; then
    CURRENT_VERSION=$(claude --version 2>/dev/null || echo "unknown")
    echo -e "${GREEN}✓ Claude Code is already installed${NC}"
    echo "Version: $CURRENT_VERSION"
    echo ""
    read -p "Do you want to reinstall/update it? (y/n) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo -e "${BLUE}Installation cancelled${NC}"
        exit 0
    fi
    echo ""
fi

# Check for required tools
if ! command -v curl &> /dev/null; then
    echo -e "${RED}✗ curl is not installed!${NC}"
    echo "Please install it first:"
    echo "  sudo apt install curl"
    exit 1
fi

echo -e "${YELLOW}Installation method options:${NC}"
echo "1. Official installer (recommended) - installs to ~/.local/bin"
echo "2. NPM installation (requires Node.js 18+)"
echo ""
read -p "Choose installation method (1 or 2): " -n 1 -r
echo
echo ""

case $REPLY in
    1)
        echo -e "${BLUE}Using official installer...${NC}"
        echo ""

        # Run official installer
        curl -fsSL https://claude.ai/install.sh | bash

        # Check if installation was successful
        if command -v claude &> /dev/null; then
            echo ""
            echo -e "${GREEN}=====================================${NC}"
            echo -e "${GREEN}  Installation Complete!${NC}"
            echo -e "${GREEN}=====================================${NC}"
            echo ""

            CLAUDE_VERSION=$(claude --version 2>/dev/null || echo "installed")
            echo -e "${GREEN}✓ Claude Code installed successfully${NC}"
            echo ""
            echo "Version: $CLAUDE_VERSION"
            echo "Install location: ~/.local/bin/claude"
        else
            echo ""
            echo -e "${YELLOW}⚠ Installation completed but claude not found in PATH${NC}"
            echo ""
            echo "You may need to restart your terminal or add to PATH:"
            echo "  export PATH=\"\$HOME/.local/bin:\$PATH\""
        fi
        ;;

    2)
        echo -e "${BLUE}Using NPM installer...${NC}"
        echo ""

        # Check if npm is installed
        if ! command -v npm &> /dev/null; then
            echo -e "${RED}✗ npm is not installed!${NC}"
            echo "Please install Node.js first:"
            echo "  ./bin/install-nvm.sh"
            echo "  nvm install --lts"
            exit 1
        fi

        echo -e "${BLUE}Installing via npm...${NC}"
        npm install -g @anthropic-ai/claude-code

        # Check if installation was successful
        if command -v claude &> /dev/null; then
            echo ""
            echo -e "${GREEN}=====================================${NC}"
            echo -e "${GREEN}  Installation Complete!${NC}"
            echo -e "${GREEN}=====================================${NC}"
            echo ""

            CLAUDE_VERSION=$(claude --version 2>/dev/null || echo "installed")
            echo -e "${GREEN}✓ Claude Code installed successfully${NC}"
            echo ""
            echo "Version: $CLAUDE_VERSION"
            echo "Install method: npm global package"
        else
            echo ""
            echo -e "${YELLOW}⚠ Installation completed but claude not found in PATH${NC}"
            echo "Check your npm global bin directory"
        fi
        ;;

    *)
        echo -e "${RED}Invalid option${NC}"
        exit 1
        ;;
esac

echo ""
echo -e "${YELLOW}Configuration:${NC}"
echo "Claude Code config is already set up at:"
echo "  ~/.claude/"
echo ""
echo "The dotfiles include:"
echo "  - CLAUDE.md (global instructions)"
echo "  - settings.json (permissions and preferences)"
echo "  - commands/ (custom slash commands)"
echo ""
echo -e "${YELLOW}Next steps:${NC}"
echo "1. Restart your terminal (or run: source ~/.zshrc)"
echo "2. Login: claude login"
echo "3. Start coding: claude"
echo ""
echo "To verify:"
echo "  claude --version"
echo "  which claude"
