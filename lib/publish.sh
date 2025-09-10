#!/bin/bash

# Zettelkasten Writer - Publishing & Draft Management
# For Digital Sovereignty Chronicle

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
NC='\033[0m'

DSC_PATH="/Users/zire/matrix/github_zire/digital-sovereignty"

save_draft_progress() {
    local post_title="$1"
    
    if [ -z "$post_title" ]; then
        echo -e "${RED}❌ Post title required${NC}"
        return 1
    fi
    
    echo -e "${BLUE}💾 Saving draft progress: $post_title${NC}"
    
    # Generate slug from title
    local slug=$(echo "$post_title" | tr '[:upper:]' '[:lower:]' | sed 's/[^a-z0-9]/-/g' | sed 's/--*/-/g' | sed 's/^-\|-$//g')
    
    # Find the post file
    local post_file=$(find "$DSC_PATH/content/posts" -name "index.md" -exec grep -l "slug: $slug" {} \; 2>/dev/null | head -1)
    
    if [ -z "$post_file" ]; then
        echo -e "${RED}❌ Post not found: $post_title${NC}"
        return 1
    fi
    
    local post_dir=$(dirname "$post_file")
    
    # Verify it's still a draft
    if ! grep -q "draft: true" "$post_file"; then
        echo -e "${YELLOW}⚠️  Post is not marked as draft${NC}"
    fi
    
    # Change to DSC directory
    cd "$DSC_PATH" || return 1
    
    # Git operations
    echo -e "${BLUE}🔄 Git operations...${NC}"
    
    # Add the post directory
    git add "$post_dir"
    
    # Check if there are changes
    if git diff --staged --quiet; then
        echo -e "${YELLOW}⚠️  No changes to save${NC}"
    else
        # Get word count
        local word_count=$(wc -w < "$post_file" | tr -d ' ')
        
        # Commit with progress info
        git commit -m "Draft progress: $post_title ($word_count words)

🚧 Work in progress - not ready for publication

🤖 Generated with [Claude Code](https://claude.ai/code)

Co-Authored-By: Claude <noreply@anthropic.com>"
        
        echo -e "${BLUE}📤 Pushing to remote...${NC}"
        git push origin main
        
        echo -e "${GREEN}✅ Draft progress saved successfully!${NC}"
        echo -e "${BLUE}📊 Word count: $word_count${NC}"
    fi
    
    return 0
}

publish_post() {
    local post_title="$1"
    
    if [ -z "$post_title" ]; then
        echo -e "${RED}❌ Post title required${NC}"
        return 1
    fi
    
    echo -e "${BLUE}🚀 Publishing post: $post_title${NC}"
    
    # Generate slug from title  
    local slug=$(echo "$post_title" | tr '[:upper:]' '[:lower:]' | sed 's/[^a-z0-9]/-/g' | sed 's/--*/-/g' | sed 's/^-\|-$//g')
    
    # Find the post file
    local post_file=$(find "$DSC_PATH/content/posts" -name "index.md" -exec grep -l "slug: $slug" {} \; 2>/dev/null | head -1)
    
    if [ -z "$post_file" ]; then
        echo -e "${RED}❌ Post not found: $post_title${NC}"
        return 1
    fi
    
    local post_dir=$(dirname "$post_file")
    
    echo -e "${BLUE}📁 Location: $post_dir${NC}"
    
    # Set draft to false
    if grep -q "draft: true" "$post_file"; then
        echo -e "${BLUE}📝 Setting draft: false${NC}"
        sed -i '' 's/draft: true/draft: false/' "$post_file"
    fi
    
    # Verify required fields
    echo -e "${BLUE}🔍 Verifying post...${NC}"
    
    local errors=0
    
    if ! grep -q "title:" "$post_file"; then
        echo -e "${RED}❌ Missing title${NC}"
        errors=$((errors + 1))
    fi
    
    if ! grep -q "date:" "$post_file"; then
        echo -e "${RED}❌ Missing date${NC}"
        errors=$((errors + 1))
    fi
    
    if ! grep -q "categories:" "$post_file"; then
        echo -e "${YELLOW}⚠️  No categories found${NC}"
    fi
    
    # Check word count
    local word_count=$(wc -w < "$post_file" | tr -d ' ')
    if [ "$word_count" -lt 100 ]; then
        echo -e "${YELLOW}⚠️  Post is very short ($word_count words)${NC}"
        echo -ne "${BLUE}Continue publishing? [y/N]:${NC} "
        read -r confirm
        if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
            echo -e "${YELLOW}Publication cancelled${NC}"
            return 1
        fi
    fi
    
    if [ "$errors" -gt 0 ]; then
        echo -e "${RED}❌ Cannot publish with $errors error(s)${NC}"
        return 1
    fi
    
    # Check for images
    local image_count=$(find "$post_dir" -name "*.webp" -o -name "*.jpg" -o -name "*.png" 2>/dev/null | wc -l | tr -d ' ')
    echo -e "${BLUE}🖼️  Images found: $image_count${NC}"
    
    # Final confirmation
    echo ""
    echo -e "${PURPLE}📊 Publication Summary:${NC}"
    echo -e "  Title: $(grep 'title:' "$post_file" | sed 's/title: "//' | sed 's/"//')"
    echo -e "  Category: $(grep -A1 'categories:' "$post_file" | tail -1 | sed 's/.*"\(.*\)".*/\1/' 2>/dev/null || echo 'none')"
    echo -e "  Word count: $word_count"
    echo -e "  Images: $image_count"
    echo ""
    echo -ne "${BLUE}Publish this post? [Y/n]:${NC} "
    read -r final_confirm
    
    if [[ "$final_confirm" =~ ^[Nn]$ ]]; then
        echo -e "${YELLOW}Publication cancelled${NC}"
        # Restore draft status
        sed -i '' 's/draft: false/draft: true/' "$post_file"
        return 1
    fi
    
    # Change to DSC directory
    cd "$DSC_PATH" || return 1
    
    # Git operations
    echo -e "${BLUE}🔄 Publishing...${NC}"
    
    # Add the post directory
    git add "$post_dir"
    
    # Commit
    git commit -m "Publish: $post_title

📝 $word_count words
🖼️ $image_count images
🏷️ $(grep -A1 'categories:' "$post_file" | tail -1 | sed 's/.*"\(.*\)".*/\1/' 2>/dev/null || echo 'general')

🤖 Generated with [Claude Code](https://claude.ai/code)

Co-Authored-By: Claude <noreply@anthropic.com>"
    
    echo -e "${BLUE}📤 Pushing to remote...${NC}"
    git push origin main
    
    echo -e "${GREEN}✅ Post published successfully!${NC}"
    echo -e "${GREEN}🚀 GitHub Actions will deploy automatically${NC}"
    echo -e "${GREEN}📧 RSS feed will update and trigger Buttondown${NC}"
    
    # Show post URL
    local post_slug=$(grep "slug:" "$post_file" | sed 's/slug: //' | tr -d ' ')
    echo -e "${GREEN}🌐 Post URL: https://digitalsovereignty.herbertyang.xyz/p/$post_slug${NC}"
    
    return 0
}

delete_draft() {
    local post_dir="$1"
    
    if [ -z "$post_dir" ]; then
        echo -e "${RED}❌ Post directory required${NC}"
        return 1
    fi
    
    if [ ! -d "$post_dir" ]; then
        echo -e "${RED}❌ Directory not found: $post_dir${NC}"
        return 1
    fi
    
    # Get post title for commit message
    local post_file="$post_dir/index.md"
    local title="Unknown"
    if [ -f "$post_file" ]; then
        title=$(grep 'title:' "$post_file" | sed 's/title: "//' | sed 's/"//' | head -1)
    fi
    
    echo -e "${RED}🗑️  Deleting draft: $title${NC}"
    echo -e "${BLUE}📁 Location: $post_dir${NC}"
    
    # Change to DSC directory
    cd "$DSC_PATH" || return 1
    
    # Convert absolute path to relative path for git
    local relative_path=$(realpath --relative-to="$DSC_PATH" "$post_dir" 2>/dev/null || echo "${post_dir#$DSC_PATH/}")
    
    echo -e "${BLUE}🔄 Git operations...${NC}"
    
    # Check if the directory is tracked by git
    if git ls-files --error-unmatch "$relative_path" >/dev/null 2>&1; then
        # Directory is tracked, use git rm
        git rm -r "$relative_path"
        
        # Commit the deletion
        git commit -m "Delete draft: $title

🗑️ Draft removed from version control

🤖 Generated with [Claude Code](https://claude.ai/code)

Co-Authored-By: Claude <noreply@anthropic.com>"
        
        echo -e "${BLUE}📤 Pushing to remote...${NC}"
        git push origin main
        
        echo -e "${GREEN}✅ Draft deleted and changes pushed!${NC}"
    else
        # Directory is not tracked, just remove it
        rm -rf "$post_dir"
        echo -e "${GREEN}✅ Untracked draft deleted!${NC}"
    fi
    
    return 0
}

start_preview() {
    echo -e "${BLUE}🌐 Starting local preview server...${NC}"
    echo -e "${PURPLE}💡 Preview will be available at: http://localhost:1313${NC}"
    echo -e "${YELLOW}Press Ctrl+C to stop the preview server${NC}"
    echo ""
    
    cd "$DSC_PATH" || return 1
    hugo server -D --bind 0.0.0.0 --baseURL http://localhost:1313
}

# Export functions
export -f save_draft_progress
export -f publish_post
export -f delete_draft
export -f start_preview