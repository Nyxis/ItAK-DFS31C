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
  mkdir -p "$release_dir/$new_folder"
  if [ $? -ne 0 ]; then
    echo "❌ Error: Failed to create release directory: $release_dir/$new_folder"
    exit 1
  fi
  echo "✅ Created: $new_folder"

  # Ensure the shared directory exists
  mkdir -p "$shared_dir"
  if [ $? -ne 0 ]; then
    echo "❌ Error: Failed to create shared directory: $shared_dir"
    exit 1
  fi

  # Check if the shared directory exists
  if [ -d "$shared_dir" ]; then
    # Create symbolic links for each file in the shared directory, preserving the directory structure
    find $shared_dir -type f | while read -r file; do
      target_dir="$release_dir/$new_folder/$(dirname "${file#$shared_dir/}")"
      mkdir -p "$target_dir"
      if [ $? -ne 0 ]; then
        echo "❌ Error: Failed to create target directory: $target_dir"
        exit 1
      fi
      ln -sfn "$file" "$target_dir/$(basename "$file")"
      if [ $? -ne 0 ]; then
        echo "❌ Error: Failed to create symlink for file: $file"
        exit 1
      fi
    done
  else
    echo "⚠️ Shared directory not found: $shared_dir"
  fi

  # Update the 'current' symlink to point to the new release
  ln -sfn "$release_dir/$new_folder" "$release_dir/current"
  if [ $? -ne 0 ]; then
    echo "❌ Error: Failed to update 'current' symlink"
    exit 1
  fi
  echo "🔗 Updated 'current' symlink to point to: $new_folder"

  # Display the release directory structure
  tree "$release_dir/$new_folder"
  if [ $? -ne 0 ]; then
    echo "❌ Error: Failed to display release directory structure"
    exit 1
  fi

  # Remove the oldest releases
  ls -t "$release_dir" | tail -n +$((keep_last_x_releases + 2)) | while read -r folder; do
    if [ "$folder" != "current" ]; then
      rm -rf "$release_dir/$folder"
      if [ $? -ne 0 ]; then
        echo "❌ Error: Failed to remove old release: $folder"
        exit 1
      fi
      echo "🗑 Removed: $folder"
    fi
  done
}

# Function to rollback to the previous release
rollback() {
  # Get the list of releases sorted by date
  releases=($(ls -t "$release_dir"))
  if [ $? -ne 0 ]; then
    echo "❌ Error: Failed to list releases in $release_dir"
    exit 1
  fi

  # Check if there are enough releases to rollback
  if [ ${#releases[@]} -lt 2 ]; then
    echo "❌ Not enough releases to rollback."
    exit 1
  fi

  # Get the current release index
  current_release=$(readlink "$release_dir/current")
  if [ $? -ne 0 ]; then
    echo "❌ Error: Failed to read current symlink"
    exit 1
  fi
  current_release=$(basename "$current_release")
  current_index=$(echo "${releases[@]}" | tr ' ' '\n' | grep -n "^$current_release$" | cut -d: -f1)
  if [ $? -ne 0 ]; then
    echo "❌ Error: Failed to find current release in the list"
    exit 1
  fi

  # Calculate the previous release index
  previous_index=$((current_index))

  # Check if the previous release exists
  if [ $previous_index -ge ${#releases[@]} ]; then
    echo "❌ No previous release to rollback to."
    exit 1
  fi

  # Get the previous release
  previous_release="${releases[$previous_index]}"

  # Update the 'current' symlink to point to the previous release
  ln -sfn "$release_dir/$previous_release" "$release_dir/current"
  if [ $? -ne 0 ]; then
    echo "❌ Error: Failed to update 'current' symlink"
    exit 1
  fi
  echo "🔙 Rolled back 'current' symlink"
  echo "   from: $current_release"
  echo "   to  : $previous_release"
}

# Parse the command
case "$1" in
  deploy)
    deploy
    ;;
    -d)
    deploy
    ;;
  rollback)
    rollback
    ;;
    -r)
    rollback
    ;;
  *)
    echo "Usage: $0 {deploy|rollback}"
    exit 1
    ;;
esac