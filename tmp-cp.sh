#!/bin/bash

# Create tmp directory if it doesn't exist
mkdir -p ./tmp

# Get list of all Elixir files tracked by git
git ls-files | grep -E '\.(ex|exs)$' | while read -r file; do
    # Get the base filename
    basename=$(basename "$file")

    # Generate a unique filename
    counter=0
    new_basename=$basename
    while [ -e "./tmp/$new_basename" ]; do
        counter=$((counter + 1))
        new_basename="${basename%.*}_${counter}.${basename##*.}"
    done

    # Copy the file to tmp with the new name
    cp "$file" "./tmp/$new_basename"
done

echo "All git-tracked Elixir files have been copied to ./tmp as a flat list"
