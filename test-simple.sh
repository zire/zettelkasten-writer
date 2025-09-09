#!/bin/bash

echo "Simple number test:"
i=1
echo "  ${i}) Test item one"
i=$((i + 1))
echo "  ${i}) Test item two"

echo ""
echo "Array test:"
items=("item one" "item two" "item three")
j=1
for item in "${items[@]}"; do
    echo "  ${j}) $item"
    j=$((j + 1))
done

echo ""
echo "Draft format test:"
draft="1|Test Title|100|50|🟡|/path/to/post"
IFS='|' read -r num title words completion icon post_dir <<< "$draft"
k=1
echo "  ${k}) $icon $title"
echo "     $words words, $completion% complete"