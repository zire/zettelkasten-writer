#!/bin/bash

# Zettelkasten Writer - Cursor Editor Integration
# Optimized for Cursor with markdown preview and writing theme

# Load theme management
LIB_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$LIB_DIR/themes.sh"

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
PURPLE='\033[0;35m'
RED='\033[0;31m'
NC='\033[0m'

open_in_cursor() {
    local file_path="$1"
    
    if [ ! -f "$file_path" ]; then
        echo -e "${RED}❌ File not found: $file_path${NC}"
        return 1
    fi
    
    echo -e "${BLUE}📝 Opening in Cursor with side-by-side markdown preview...${NC}"
    echo -e "${PURPLE}💡 Setting up optimal writing environment${NC}"
    echo ""
    
    # Switch to writing theme first
    switch_to_writing_theme
    
    # Check if Cursor is installed
    if command -v cursor > /dev/null 2>&1; then
        # Open file in Cursor
        cursor "$file_path"
        
        # Give Cursor a moment to start
        sleep 2
        
        # Try to set up side-by-side view via AppleScript (macOS)
        if [[ "$OSTYPE" == "darwin"* ]]; then
            osascript -e 'tell application "Cursor" to activate' 2>/dev/null || true
            sleep 1
            
            # Hide explorer panel (Cmd+Shift+E)
            osascript -e 'tell application "System Events" to keystroke "e" using {command down, shift down}' 2>/dev/null || true
            sleep 1
            
            # Enter Zen mode to hide line numbers and distractions (Cmd+R Z)
            osascript -e 'tell application "System Events" to keystroke "r" using {command down}' 2>/dev/null || true
            sleep 0.5
            osascript -e 'tell application "System Events" to keystroke "z"' 2>/dev/null || true
            sleep 1
            
            # Split editor right (Cmd+\)
            osascript -e 'tell application "System Events" to keystroke "\\" using {command down}' 2>/dev/null || true
            sleep 1
            
            # Open markdown preview in the right pane (Cmd+Shift+V)
            osascript -e 'tell application "System Events" to keystroke "v" using {command down, shift down}' 2>/dev/null || true
        fi
        
        echo -e "${GREEN}✅ Cursor opened with side-by-side preview${NC}"
        
    else
        echo -e "${RED}❌ Cursor not found!${NC}"
        echo -e "${YELLOW}Please install Cursor from https://cursor.sh/${NC}"
        echo -e "${BLUE}📝 File location: $file_path${NC}"
        return 1
    fi
    
    echo ""
    echo -e "${PURPLE}📋 Writing environment ready:${NC}"
    echo -e "  • Zen mode enabled (no line numbers, minimal UI)"
    echo -e "  • Editor on left, preview on right"
    echo -e "  • Explorer panel hidden for focus"
    echo -e "  • 💡 Close the redundant index.md tab in right pane"
    echo -e "  • Type 'img' + Tab for image insertion"
    echo -e "  • Type 'figure' + Tab for captioned images"  
    echo -e "  • AI assistance with Cmd+K"
    echo -e "  • Code Spell Checker for grammar and spelling"
    echo ""
    echo -e "${BLUE}💾 Auto-save is enabled - your changes are preserved${NC}"
    
    return 0
}

show_writing_session_commands() {
    echo -e "${PURPLE}📝 Writing Session Commands:${NC}"
    echo ""
    echo -e "${BLUE}In another terminal window/tab, you can run:${NC}"
    echo -e "  ${GREEN}./zwrite save${NC}     - Save draft progress to git"
    echo -e "  ${GREEN}./zwrite publish${NC}  - Publish completed post"
    echo -e "  ${GREEN}./zwrite status${NC}   - Check all drafts"
    echo ""
    echo -e "${YELLOW}💡 Tip: Keep this terminal open for quick commands!${NC}"
}

# Export functions
export -f open_in_cursor
export -f show_writing_session_commands