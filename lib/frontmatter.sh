#!/bin/bash

# Zettelkasten Writer - Smart Frontmatter Wizard
# Multi-site support

# Source previous issues generator for Sunday Blender
LIB_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$LIB_DIR/previous_issues.sh"

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
    printf "${GREEN}Title:${NC} "
    read -r title
    if [ -z "$title" ]; then
        echo -e "${RED}Title is required.${NC}"
        return 1
    fi
    
    # Generate slug from title
    local slug=$(echo "$title" | tr '[:upper:]' '[:lower:]' | sed 's/[^a-z0-9]/-/g' | sed 's/--*/-/g' | sed 's/^-\|-$//g')
    printf "${GREEN}Slug${NC} ${GRAY}(auto-generated):${NC} $slug ${GRAY}[Enter to accept, or type new]:${NC} "
    read -r custom_slug
    if [ -n "$custom_slug" ]; then
        slug="$custom_slug"
    fi
    
    # Date (default to now)
    local current_date=$(date -u +"%Y-%m-%dT%H:%M:%S+00:00")
    printf "${GREEN}Date${NC} ${GRAY}(default: now):${NC} $current_date ${GRAY}[Enter to accept, or type new]:${NC} "
    read -r custom_date
    if [ -n "$custom_date" ]; then
        current_date="$custom_date"
    fi
    
    # Description
    printf "${GREEN}Description${NC} ${GRAY}(brief summary):${NC} "
    read -r description
    if [ -z "$description" ]; then
        description="Brief description of the post"
    fi
    
    # Category
    echo -e "${GREEN}Category${NC} ${GRAY}(choose from common options):${NC}"
    echo -e "  1) crypto    2) ai         3) blockchain   4) web3"
    echo -e "  5) defi      6) podcast    7) tech         8) digital-life"
    printf "${GREEN}Choice [1-8] or type custom:${NC} "
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
    local post_dir="/Users/zire/matrix/github_zire/digital-sovereignty/content/posts/$current_year/$current_month/$current_day-$slug"
    
    # Check if directory exists
    if [ -d "$post_dir" ]; then
        echo -e "${YELLOW}⚠️  Directory already exists: $post_dir${NC}"
        printf "${BLUE}Continue anyway? [y/N]:${NC} "
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
    POST_FILE_RESULT="$post_file"
    return 0
}

create_sb_frontmatter() {
    echo -e "${BLUE}📝 Creating new post for The Sunday Blender${NC}"
    echo ""
    
    # Title
    printf "${GREEN}Title:${NC} "
    read -r title
    if [ -z "$title" ]; then
        echo -e "${RED}Title is required.${NC}"
        return 1
    fi
    
    # Generate slug from title  
    local slug=$(echo "$title" | tr '[:upper:]' '[:lower:]' | sed 's/[^a-z0-9]/-/g' | sed 's/--*/-/g' | sed 's/^-\|-$//g')
    printf "${GREEN}Slug${NC} ${GRAY}(auto-generated):${NC} $slug ${GRAY}[Enter to accept, or type new]:${NC} "
    read -r custom_slug
    if [ -n "$custom_slug" ]; then
        slug="$custom_slug"
    fi
    
    # Date (for Saturday publication)
    printf "${GREEN}Date${NC} ${GRAY}(YYYY-MM-DD format, or Enter for today):${NC} "
    read -r input_date
    
    if [ -z "$input_date" ]; then
        current_date=$(date +"%Y-%m-%d")
    else
        # Validate YYYY-MM-DD format and show day of week
        if date -j -f "%Y-%m-%d" "$input_date" "+%A, %B %d, %Y" >/dev/null 2>&1; then
            local day_info=$(date -j -f "%Y-%m-%d" "$input_date" "+%A, %B %d, %Y")
            echo -e "${BLUE}Publishing on: $day_info${NC}"
            current_date="$input_date"
        else
            echo -e "${RED}Invalid date format. Using today.${NC}"
            current_date=$(date +"%Y-%m-%d")
        fi
    fi
    
    # Description (optional for SB)
    printf "${GREEN}Description${NC} ${GRAY}(brief summary, optional):${NC} "
    read -r description
    
    # Tags (manual entry)
    echo ""
    printf "${GREEN}Tags${NC} ${GRAY}(comma-separated, default: news):${NC} "
    read -r tags
    if [ -z "$tags" ]; then
        tags="news"
    fi
    
    # Generate directory structure (SB uses YYYY/MM/MMDD format)
    local current_year=$(date +%Y)
    local current_month=$(date +%m) 
    local current_day=$(date +%d)
    local post_dir="/Users/zire/matrix/github_zire/sundayblender/content/posts/$current_year/$current_month/$current_month$current_day-$slug"
    
    # Check if directory exists
    if [ -d "$post_dir" ]; then
        echo -e "${YELLOW}⚠️  Directory already exists: $post_dir${NC}"
        printf "${BLUE}Continue anyway? [y/N]:${NC} "
        read -r continue_choice
        if [[ ! "$continue_choice" =~ ^[Yy]$ ]]; then
            return 1
        fi
    fi
    
    # Create directory
    mkdir -p "$post_dir"
    if [ $? -ne 0 ]; then
        echo -e "${RED}❌ Failed to create directory: $post_dir${NC}"
        return 1
    fi
    
    # Create the post file
    local post_file="$post_dir/index.md"
    
    # Generate frontmatter and content with Previous Issues
    local previous_issues_content=$(generate_previous_issues)
    
    cat > "$post_file" << POSTEOF
---
title: "$title"
date: $current_date
slug: $slug
description: "$description"
tags: [$tags]
draft: true
---

![Hero Image]()

## Tech

## Global

## Economy & Finance

## Nature & Environment

## Lifestyle, Entertainment & Culture

## Sports

## This Day in History

## Art of the Week

## Funny
$previous_issues_content

---

Thanks for reading! If you enjoy this newsletter, please share it with friends who might also find it interesting and refreshing, if not for themselves, at least for their kids.

POSTEOF
    
    echo -e "${GREEN}✅ Post created successfully!${NC}"
    echo -e "${BLUE}📁 Location: $post_dir${NC}"
    echo ""
    echo -e "${GRAY}Next steps:${NC}"
    echo -e "  1. Write your content in the editor"
    echo -e "  2. Set ${YELLOW}draft: false${NC} when ready to publish"
    echo -e "  3. Preview: cd $post_dir && hugo server -D"
    echo -e "  4. Publish when ready"
    
    # Return the post file path for opening in editor
    POST_FILE_RESULT="$post_file"
    return 0
}

create_hy_frontmatter() {
    echo -e "${BLUE}📝 Creating new post for Herbert Yang (Personal)${NC}"
    echo ""
    
    # Title
    printf "${GREEN}Title:${NC} "
    read -r title
    if [ -z "$title" ]; then
        echo -e "${RED}Title is required.${NC}"
        return 1
    fi
    
    # Generate slug from title
    local slug=$(echo "$title" | tr '[:upper:]' '[:lower:]' | sed 's/[^a-z0-9]/-/g' | sed 's/--*/-/g' | sed 's/^-\|-$//g')
    printf "${GREEN}Slug${NC} ${GRAY}(auto-generated):${NC} $slug ${GRAY}[Enter to accept, or type new]:${NC} "
    read -r custom_slug
    if [ -n "$custom_slug" ]; then
        slug="$custom_slug"
    fi
    
    # Date (default to now)
    local current_date=$(date +"%Y-%m-%d")
    printf "${GREEN}Date${NC} ${GRAY}(YYYY-MM-DD, default: today):${NC} $current_date ${GRAY}[Enter to accept, or type new]:${NC} "
    read -r custom_date
    if [ -n "$custom_date" ]; then
        current_date="$custom_date"
    fi
    
    # Description
    printf "${GREEN}Description${NC} ${GRAY}(brief summary, optional):${NC} "
    read -r description
    
    # Tags (default: personal)
    printf "${GREEN}Tags${NC} ${GRAY}(comma-separated, default: personal):${NC} "
    read -r tags
    if [ -z "$tags" ]; then
        tags="personal"
    fi
    
    # Convert comma-separated tags to array format
    local tag_array=""
    IFS=',' read -ra tag_list <<< "$tags"
    for tag in "${tag_list[@]}"; do
        tag=$(echo "$tag" | sed 's/^[ \t]*//;s/[ \t]*$//')  # trim whitespace
        if [ -n "$tag_array" ]; then
            tag_array="${tag_array}, \"$tag\""
        else
            tag_array="\"$tag\""
        fi
    done
    
    # Create directory structure based on date and slug (like DSC)
    local hy_path="/Users/zire/matrix/github_zire/herbertyang.xyz"
    local year=$(echo "$current_date" | cut -d'-' -f1)
    local post_dir="$hy_path/docusaurus/blog/$year/$current_date-$slug"
    local post_file="$post_dir/index.md"
    
    # Ensure post directory exists
    mkdir -p "$post_dir"
    
    # Create the post file with Docusaurus frontmatter
    cat > "$post_file" << EOF
---
title: $title
date: $current_date
authors: [herbert]
tags: [$tag_array]
draft: true
EOF
    
    # Add description if provided
    if [ -n "$description" ]; then
        cat >> "$post_file" << EOF
description: $description
EOF
    fi
    
    cat >> "$post_file" << EOF
---

## Introduction

## Main Content

## Conclusion

---

*Originally published on [herbertyang.xyz](https://herbertyang.xyz)*
EOF
    
    echo ""
    echo -e "${GREEN}✅ Post created successfully!${NC}"
    echo -e "${BLUE}📝 File:${NC} $post_file"
    echo ""
    echo -e "${PURPLE}Next steps:${NC}"
    echo -e "  1. Write your content"
    echo -e "  2. Set ${YELLOW}draft: false${NC} when ready to publish"
    echo -e "  3. Preview: cd $hy_path/docusaurus && npm start"
    echo -e "  4. Publish when ready"
    
    # Return the post file path for opening in editor
    POST_FILE_RESULT="$post_file"
    return 0
}

# Export functions
export -f create_dsc_frontmatter
export -f create_sb_frontmatter
export -f create_hy_frontmatter