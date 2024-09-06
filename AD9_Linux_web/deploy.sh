#!/bin/bash

# Default number of releases to keep
keep_last_x_releases=5

# Define the release directory
release_dir="project/release"
shared_dir="project/shared"

# Function to deploy a new release
deploy() {
  # Create the subdirectory with the current date in project/release
  new_folder=$(date '+%Y-%m-%d-%H:%M:%S')
  mkdir -p "$release_dir/$new_folder" && 
  echo "✅ Created: $new_folder"

  # Create symbolic links for each file in the shared directory, preserving the directory structure
  find $shared_dir -type f | while read -r file; do
    target_dir="$release_dir/$new_folder/$(dirname "${file#$shared_dir/}")"
    mkdir -p "$target_dir"
    ln -sfn "$file" "$target_dir/$(basename "$file")"
  done

  # Update the 'current' symlink to point to the new release
  ln -sfn "$release_dir/$new_folder" "$release_dir/current"
  echo "🔗 Updated 'current' symlink to point to: $new_folder"

  # Display the release directory structure
  tree "$release_dir/$new_folder"

  # Remove the oldest releases
  ls -t "$release_dir" | tail -n +$((keep_last_x_releases + 2)) | while read -r folder; do
    if [ "$folder" != "current" ]; then
      rm -rf "$release_dir/$folder"
      echo "🗑 Removed: $folder"
    fi
  done
}

# Function to rollback to the previous release
rollback() {
  # Get the list of releases sorted by date
  releases=($(ls -t "$release_dir"))

  # Check if there are enough releases to rollback
  if [ ${#releases[@]} -lt 2 ]; then
    echo "❌ Not enough releases to rollback."
    exit 1
  fi

  # Get the current release index
  current_release=$(readlink "$release_dir/current")
  current_release=$(basename "$current_release")
  current_index=$(echo "${releases[@]}" | tr ' ' '\n' | grep -n "^$current_release$" | cut -d: -f1)

  # Calculate the previous release index
  previous_index=$((current_index))

  # Check if the previous release exists
  if [ $previous_index -ge ${#releases[@]} ]; then
    echo "❌ No previous release to rollback to."
    exit 1
  fi

  # Update the 'current' symlink to point to the previous release
  ln -sfn "$release_dir/${releases[$previous_index]}" "$release_dir/current"
  echo "🔙 Rolled back 'current' symlink to: ${releases[$previous_index]}"
}

# Parse the command
case "$1" in
  deploy)
    deploy
    ;;
  rollback)
    rollback
    ;;
  *)
    echo -e "❌ERROR: \n→ Usage: $0 {deploy|rollback}"
    exit 1
    ;;
esac