#!/bin/bash

# Find all files in the shared directory, create symbolic links in the release folder
find "project/shared" -type f -print0 | while IFS= read -r -d '' file; do  
  # Create the corresponding directory structure in the release folder, if it doesn't exist
  mkdir -p "project/current/release"
  
  # Create a symbolic link in the new directory, pointing to the original file
  ln -s "$PWD/$file" "$PWD/project/current/release/$(basename "$file")"
done