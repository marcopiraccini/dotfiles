#!/bin/bash

# Install Rust and common components
# Uses rustup - the official Rust installer

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}=====================================${NC}"
echo -e "${BLUE}  Rust Installer${NC}"
echo -e "${BLUE}=====================================${NC}"
echo ""

# Check if required tools are installed
if ! command -v curl &> /dev/null; then
    echo -e "${RED}✗ curl is not installed!${NC}"
    echo "Installing curl..."
    sudo apt install -y curl
fi

# Check if Rust is already installed
if command -v rustc &> /dev/null; then
    CURRENT_VERSION=$(rustc --version)
    echo -e "${YELLOW}⚠ Rust is already installed${NC}"
    echo "Current version: $CURRENT_VERSION"
    echo ""
    read -p "Do you want to update it? (y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        echo -e "${BLUE}Updating Rust...${NC}"
        rustup update
        echo -e "${GREEN}✓ Rust updated successfully${NC}"

        # Update components
        echo ""
        echo -e "${BLUE}Updating rust-analyzer...${NC}"
        rustup component add rust-analyzer 2>/dev/null || echo -e "${YELLOW}⚠ rust-analyzer already installed${NC}"

        echo ""
        NEW_VERSION=$(rustc --version)
        echo -e "${GREEN}✓ Updated to: $NEW_VERSION${NC}"
        exit 0
    else
        echo -e "${BLUE}Skipping installation${NC}"
        exit 0
    fi
fi

# Check for required build tools
echo -e "${BLUE}Checking for required build tools...${NC}"

MISSING_TOOLS=()

if ! command -v gcc &> /dev/null; then
    MISSING_TOOLS+=("gcc")
fi

if ! command -v make &> /dev/null; then
    MISSING_TOOLS+=("make")
fi

if [ ${#MISSING_TOOLS[@]} -ne 0 ]; then
    echo -e "${YELLOW}⚠ Missing build tools: ${MISSING_TOOLS[*]}${NC}"
    echo -e "${BLUE}Installing build-essential...${NC}"
    sudo apt install -y build-essential
    echo -e "${GREEN}✓ Build tools installed${NC}"
else
    echo -e "${GREEN}✓ Build tools available${NC}"
fi

echo ""

# Install Rust using rustup
echo -e "${BLUE}Downloading and installing Rust...${NC}"
echo ""

# Download and run rustup installer
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y

if [ $? -ne 0 ]; then
    echo -e "${RED}✗ Installation failed${NC}"
    exit 1
fi

echo ""
echo -e "${GREEN}✓ Rust installed successfully${NC}"
echo ""

# Load Rust environment for current session
source "$HOME/.cargo/env"

# Verify installation
if command -v rustc &> /dev/null; then
    RUST_VERSION=$(rustc --version)
    CARGO_VERSION=$(cargo --version)

    echo -e "${BLUE}Installing additional components...${NC}"

    # Install rust-analyzer
    echo -e "${BLUE}Installing rust-analyzer...${NC}"
    rustup component add rust-analyzer

    if command -v rust-analyzer &> /dev/null; then
        RA_VERSION=$(rust-analyzer --version)
        echo -e "${GREEN}✓ rust-analyzer installed: $RA_VERSION${NC}"
    else
        echo -e "${YELLOW}⚠ rust-analyzer installed but not in PATH yet${NC}"
    fi

    echo ""
    echo -e "${GREEN}=====================================${NC}"
    echo -e "${GREEN}  Installation Complete!${NC}"
    echo -e "${GREEN}=====================================${NC}"
    echo ""
    echo -e "${GREEN}✓ $RUST_VERSION${NC}"
    echo -e "${GREEN}✓ $CARGO_VERSION${NC}"
    echo -e "${GREEN}✓ rust-analyzer installed${NC}"
    echo ""
    echo "Installation directory: $HOME/.cargo"
    echo ""
    echo -e "${YELLOW}Next steps:${NC}"
    echo "1. Restart your terminal or run:"
    echo "   source \$HOME/.cargo/env"
    echo "   # Or for zsh (already in .zshrc):"
    echo "   source ~/.zshrc"
    echo ""
    echo "2. Verify installation:"
    echo "   rustc --version"
    echo "   cargo --version"
    echo ""
    echo "3. Create a new Rust project:"
    echo "   cargo new hello-world"
    echo "   cd hello-world"
    echo "   cargo run"
    echo ""
    echo "4. Update Rust in the future:"
    echo "   rustup update"
    echo ""
    echo -e "${BLUE}Useful cargo commands:${NC}"
    echo "  cargo build       - Compile the project"
    echo "  cargo run         - Compile and run"
    echo "  cargo test        - Run tests"
    echo "  cargo check       - Check for errors (faster than build)"
    echo "  cargo doc --open  - Generate and open documentation"
else
    echo -e "${YELLOW}⚠ Rust installed but not available in current session${NC}"
    echo "Please restart your terminal or run: source \$HOME/.cargo/env"
fi
