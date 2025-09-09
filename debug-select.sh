#!/bin/bash

# Debug script to test draft selection

source lib/menu.sh

echo "Testing draft selection..."
echo ""

# Get drafts
drafts=()
while IFS= read -r line; do
    drafts+=("$line")
done < <(get_dsc_drafts)

echo "Found ${#drafts[@]} drafts"
echo ""

# Display them with numbers
local i=1
for draft in "${drafts[@]}"; do
    IFS='|' read -r orig_num title words completion icon post_dir <<< "$draft"
    echo "  ${i}) ${icon} ${title}"
    echo "     ${words} words, ${completion}% complete"
    echo ""
    i=$((i + 1))
done