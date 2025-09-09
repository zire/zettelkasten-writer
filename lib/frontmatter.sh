#!/bin/bash

# Zettelkasten Writer - Smart Frontmatter Wizard
# Focused on Digital Sovereignty Chronicle

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
GRAY='\033[0;90m'
NC='\033[0m'
BOLD='\033[1m'

create_dsc_frontmatter() {
    echo -e "${BLUE}📝 Creating new post for Digital Sovereignty Chronicle${NC}"
    echo ""
    
    # Title
    echo -ne "${GREEN}Title:${NC} "
    read -r title
    if [ -z "$title" ]; then
        echo -e "${RED}Title is required.${NC}"
        return 1
    fi
    
    # Generate slug from title
    local slug=$(echo "$title" | tr '[:upper:]' '[:lower:]' | sed 's/[^a-z0-9]/-/g' | sed 's/--*/-/g' | sed 's/^-\|-$//g')
    echo -ne "${GREEN}Slug${NC} ${GRAY}(auto-generated):${NC} $slug ${GRAY}[Enter to accept, or type new]:${NC} "
    read -r custom_slug
    if [ -n "$custom_slug" ]; then
        slug="$custom_slug"
    fi
    
    # Date (default to now)
    local current_date=$(date -u +"%Y-%m-%dT%H:%M:%S+00:00")
    echo -ne "${GREEN}Date${NC} ${GRAY}(default: now):${NC} $current_date ${GRAY}[Enter to accept, or type new]:${NC} "
    read -r custom_date
    if [ -n "$custom_date" ]; then
        current_date="$custom_date"
    fi
    
    # Description
    echo -ne "${GREEN}Description${NC} ${GRAY}(brief summary):${NC} "
    read -r description
    if [ -z "$description" ]; then
        description="Brief description of the post"
    fi
    
    # Category
    echo -e "${GREEN}Category${NC} ${GRAY}(choose from common options):${NC}"
    echo -e "  1) crypto    2) ai         3) blockchain   4) web3"
    echo -e "  5) defi      6) podcast    7) tech         8) digital-life"
    echo -ne "${GREEN}Choice [1-8] or type custom:${NC} "
    read -r cat_choice
    
    local category="crypto" # default
    case "$cat_choice" in
        1) category="crypto" ;;
        2) category="ai" ;;
        3) category="blockchain" ;;
        4) category="web3" ;;
        5) category="defi" ;;
        6) category="podcast" ;;
        7) category="tech" ;;
        8) category="digital-life" ;;
        [0-9]*) category="crypto" ;; # invalid number, use default
        *) if [ -n "$cat_choice" ]; then category="$cat_choice"; fi ;;
    esac
    
    # Series (optional)
    echo -e "${GREEN}Series${NC} ${GRAY}(optional - common: weekly-updates, deep-dive, crypto-101):${NC} "
    read -r series
    
    # Generate directory structure
    local current_year=$(date +%Y)
    local current_month=$(date +%m) 
    local current_day=$(date +%d)
    local post_dir="/Users/zire/github_zire/digital-sovereignty/content/posts/$current_year/$current_month/$current_day-$slug"
    
    # Check if directory exists
    if [ -d "$post_dir" ]; then
        echo -e "${YELLOW}⚠️  Directory already exists: $post_dir${NC}"
        echo -ne "${BLUE}Continue anyway? [y/N]:${NC} "
        read -r confirm
        if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
            return 1
        fi
    fi
    
    # Create directory
    mkdir -p "$post_dir"
    
    # Create frontmatter
    local post_file="$post_dir/index.md"
    cat > "$post_file" << EOF
---
title: "$title"
date: $current_date
slug: $slug
draft: true
description: "$description"
categories:
  - "$category"
EOF
    
    # Add series if provided
    if [ -n "$series" ]; then
        cat >> "$post_file" << EOF
series:
  - "$series"
EOF
    fi
    
    cat >> "$post_file" << EOF
---

<!-- Featured image for social media -->
![Featured Image](./featured-image.webp)

## Introduction

## Main Content

## Conclusion

---

*Published in [Digital Sovereignty Chronicle](https://digitalsovereignty.herbertyang.xyz/) - Breaking down complex crypto concepts, exploring digital sovereignty, and sharing insights from the frontier of decentralized technology.*
EOF
    
    echo ""
    echo -e "${GREEN}✅ Post created successfully!${NC}"
    echo -e "${BLUE}📁 Location:${NC} $post_dir"
    echo -e "${BLUE}📝 File:${NC} $post_file"
    echo ""
    echo -e "${PURPLE}Next steps:${NC}"
    echo -e "  1. Add images to the post directory"
    echo -e "  2. Write your content"
    echo -e "  3. Preview: cd $post_dir && hugo server -D"
    echo -e "  4. Publish when ready"
    
    # Return the post file path for opening in editor
    echo "$post_file"
    return 0
}

# Export function
export -f create_dsc_frontmatter