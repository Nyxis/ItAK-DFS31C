#!/bin/bash

# Find all files in the shared directory, preserve directory structure when copying
find "project/shared" -type f -print0 | while IFS= read -r -d '' file; do  
  # Create the corresponding directory structure in the release folder
  mkdir -p "project/current/release/shared"
  
  # Copy the file to the new directory, maintaining the structure
  cp "$file" "project/current/release/shared"
done