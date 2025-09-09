#!/bin/bash

# Zettelkasten Writer - Session Management
# Handle writing session start/end with theme switching

# Load theme management
LIB_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$LIB_DIR/themes.sh"

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
PURPLE='\033[0;35m'
NC='\033[0m'

end_writing_session() {
    echo ""
    echo -e "${PURPLE}📝 Writing session ending...${NC}"
    
    # Restore coding theme
    switch_to_coding_theme
    
    echo -e "${GREEN}✅ Ready to return to coding environment${NC}"
}

show_session_end_options() {
    echo ""
    echo -e "${BLUE}💾 Writing session options:${NC}"
    echo -e "  ${GREEN}s)${NC} Save draft progress to git"
    echo -e "  ${GREEN}p)${NC} Publish this post"  
    echo -e "  ${GREEN}c)${NC} Continue writing (keep theme)"
    echo -e "  ${GREEN}q)${NC} End session and restore coding theme"
    echo ""
    echo -ne "${BLUE}Your choice [s/p/c/q]:${NC} "
}

# Export functions
export -f end_writing_session
export -f show_session_end_options