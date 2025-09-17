#!/bin/bash

# Zettelkasten Writer - Theme Management
# Automatic switching between coding and writing themes

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

CURSOR_SETTINGS_PATH="$HOME/Library/Application Support/Cursor/User/settings.json"

switch_to_writing_theme() {
    echo -e "${BLUE}🎨 Switching to paper writing theme...${NC}"
    
    # Backup current settings
    cp "$CURSOR_SETTINGS_PATH" "$CURSOR_SETTINGS_PATH.backup" 2>/dev/null || true
    
    # Create writing theme settings using jq or sed
    if command -v jq > /dev/null 2>&1; then
        # Use jq for clean JSON modification
        jq '. + {
            "workbench.colorTheme": "Quiet Light",
            "editor.fontFamily": "Georgia, \"Times New Roman\", serif",
            "editor.fontSize": 16,
            "editor.lineHeight": 1.6,
            "editor.fontLigatures": false,
            "workbench.colorCustomizations": {
                "editor.background": "#fefcf6",
                "editor.foreground": "#2d2d2d",
                "editorLineNumber.foreground": "#d0c5b8",
                "editor.selectionBackground": "#e8dcc6",
                "editorCursor.foreground": "#8b7355"
            }
        }' "$CURSOR_SETTINGS_PATH" > "$CURSOR_SETTINGS_PATH.tmp" && mv "$CURSOR_SETTINGS_PATH.tmp" "$CURSOR_SETTINGS_PATH"
    else
        # Fallback: simple theme change using sed
        sed -i '' 's/"workbench.colorTheme": "Community Material Theme"/"workbench.colorTheme": "Quiet Light"/g' "$CURSOR_SETTINGS_PATH" 2>/dev/null || true
    fi
    
    echo -e "${GREEN}✅ Paper writing theme applied${NC}"
    echo -e "${YELLOW}💡 Restart Cursor or reload window (Cmd+R) to see changes${NC}"
}

switch_to_coding_theme() {
    echo -e "${BLUE}🎨 Restoring coding theme...${NC}"

    # Use jq to restore Community Material Theme and remove writing customizations
    if command -v jq > /dev/null 2>&1; then
        # Restore Community Material Theme and remove writing-specific settings
        jq '{
            "window.commandCenter": true,
            "workbench.colorTheme": "Community Material Theme",
            "editor.accessibilitySupport": "on",
            "extensions.ignoreRecommendations": true,
            "cursor.composer.usageSummaryDisplay": "always",
            "editor.fontFamily": "Fira Code, Menlo, Monaco, \"Courier New\", monospace",
            "editor.fontSize": 14,
            "editor.lineHeight": 1.4,
            "editor.fontLigatures": true,
            "terminal.integrated.fontFamily": "Fira Code, Menlo, Monaco, \"Courier New\", monospace"
        }' "$CURSOR_SETTINGS_PATH" > "$CURSOR_SETTINGS_PATH.tmp" && mv "$CURSOR_SETTINGS_PATH.tmp" "$CURSOR_SETTINGS_PATH"
        echo -e "${GREEN}✅ Community Material Theme restored${NC}"
    else
        # Fallback: restore backup settings if available
        if [ -f "$CURSOR_SETTINGS_PATH.backup" ]; then
            cp "$CURSOR_SETTINGS_PATH.backup" "$CURSOR_SETTINGS_PATH" 2>/dev/null || true
            echo -e "${GREEN}✅ Coding theme restored from backup${NC}"
        else
            # Simple sed fallback
            sed -i '' 's/"workbench.colorTheme": "Quiet Light"/"workbench.colorTheme": "Community Material Theme"/g' "$CURSOR_SETTINGS_PATH" 2>/dev/null || true
            echo -e "${YELLOW}💡 Theme switched back to Community Material Theme${NC}"
        fi
    fi
}

# Export functions
export -f switch_to_writing_theme
export -f switch_to_coding_theme