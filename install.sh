#!/bin/bash

# Zettelkasten Writer - Installation Script

set -e

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
PURPLE='\033[0;35m'
NC='\033[0m'

echo -e "${BLUE}🚀 Installing Zettelkasten Writer...${NC}"
echo ""

# Get the directory where this script is located
INSTALL_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Make scripts executable
chmod +x "$INSTALL_DIR/zwrite"
chmod +x "$INSTALL_DIR/lib/"*.sh

echo -e "${GREEN}✅ Made scripts executable${NC}"

# Create symlink in PATH (optional)
if [ -d "/usr/local/bin" ] && [ -w "/usr/local/bin" ]; then
    if [ ! -L "/usr/local/bin/zwrite" ]; then
        ln -s "$INSTALL_DIR/zwrite" "/usr/local/bin/zwrite"
        echo -e "${GREEN}✅ Created symlink: /usr/local/bin/zwrite${NC}"
        echo -e "${BLUE}💡 You can now run 'zwrite' from anywhere${NC}"
    else
        echo -e "${YELLOW}⚠️  Symlink already exists: /usr/local/bin/zwrite${NC}"
    fi
else
    echo -e "${YELLOW}⚠️  Could not create global symlink${NC}"
    echo -e "${BLUE}💡 Run directly: $INSTALL_DIR/zwrite${NC}"
fi

# Create backup directory
mkdir -p "$HOME/.zirewriter-backups"
echo -e "${GREEN}✅ Created backup directory${NC}"

# Check dependencies
echo ""
echo -e "${BLUE}🔍 Checking dependencies...${NC}"

if command -v cursor > /dev/null 2>&1; then
    echo -e "${GREEN}✅ Cursor editor found${NC}"
else
    echo -e "${YELLOW}⚠️  Cursor not found - install from https://cursor.sh/${NC}"
fi

if command -v hugo > /dev/null 2>&1; then
    echo -e "${GREEN}✅ Hugo found${NC}"
else
    echo -e "${YELLOW}⚠️  Hugo not found - some preview features may not work${NC}"
fi

if command -v git > /dev/null 2>&1; then
    echo -e "${GREEN}✅ Git found${NC}"
else
    echo -e "${YELLOW}⚠️  Git not found - publishing features may not work${NC}"
fi

echo ""
echo -e "${PURPLE}🎉 Installation complete!${NC}"
echo ""
echo -e "${BLUE}Quick start:${NC}"
echo -e "  1. Run: ${GREEN}./zwrite${NC} (or just ${GREEN}zwrite${NC} if symlink created)"
echo -e "  2. Select 'Digital Sovereignty Chronicle'"
echo -e "  3. Choose 'Create new post'"
echo -e "  4. Follow the prompts"
echo -e "  5. Write in Cursor with markdown preview"
echo -e "  6. Publish when ready!"
echo ""
echo -e "${YELLOW}💡 Pro tip: Keep a terminal open for quick commands like:${NC}"
echo -e "  ${GREEN}zwrite save \"Post Title\"${NC}"  
echo -e "  ${GREEN}zwrite publish \"Post Title\"${NC}"
echo -e "  ${GREEN}zwrite preview${NC}"