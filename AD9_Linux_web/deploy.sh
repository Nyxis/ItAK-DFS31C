#!/bin/bash

# Load environment variables from the .env file if it exists
if [ -f .env ]; then
  source .env
fi

# Default number of releases to keep
keep_last_x_releases=${KEEP_LAST_X_RELEASES:-5}

# Define the release directory
release_dir=${RELEASE_DIR:-"project/release"}
shared_dir=${SHARED_DIR:-"project/shared"}
repo_url=${REPO_URL:-""}
branch_or_tag=${BRANCH_OR_TAG:-""}
clone_folder=${CLONE_FOLDER:-""}

# Function to check if Git is installed
check_git() {
  if ! command -v git &> /dev/null; then
    echo "❌ Error: Git is not installed or not accessible."
    exit 1
  fi
}

# Function to deploy a new release
deploy() {
  # Check if Git is available
  check_git

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

  # Clone the specific repository, branch/tag, and folder
  echo "🔄 Cloning repository $repo_url (branch/tag: $branch_or_tag)..."
  git clone --branch "$branch_or_tag" --depth 1 "$repo_url" "$release_dir/$new_folder" --single-branch
  if [ $? -ne 0 ]; then
    echo "❌ Error: Failed to clone repository: $repo_url"
    exit 1
  fi

  # If specific folder to clone is set, move to that folder
  if [ "$clone_folder" != "." ]; then
    if [ -d "$release_dir/$new_folder/$clone_folder" ]; then
      mv "$release_dir/$new_folder/$clone_folder"/* "$release_dir/$new_folder/"
      rm -rf "$release_dir/$new_folder/$clone_folder"
    else
      echo "❌ Error: Specified folder '$clone_folder' not found in repository."
      exit 1
    fi
  fi

  # Create symbolic links for shared files
  if [ -d "$shared_dir" ]; then
    find "$shared_dir" -type f | while read -r file; do
      target_dir="$release_dir/$new_folder/$(dirname "${file#$shared_dir/}")"
      mkdir -p "$target_dir"
      ln -sfn "$file" "$target_dir/$(basename "$file")"
    done
  fi

  # Update 'current' symlink
  ln -sfn "$release_dir/$new_folder" "$release_dir/current"
  echo "🔗 Updated 'current' symlink to: $new_folder"

  # Display release structure
  tree "$release_dir/$new_folder"

  # Remove old releases
  ls -t "$release_dir" | tail -n +$((keep_last_x_releases + 2)) | while read -r folder; do
    if [ "$folder" != "current" ]; then
      rm -rf "$release_dir/$folder"
      echo "🗑 Removed old release: $folder"
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

# Function to build the last release
build_last_release() {
  current_release=$(readlink "$release_dir/current")
  if [ $? -ne 0 ]; then
    echo "❌ Error: Failed to read current symlink"
    exit 1
  fi

  # Traverse directories to find a Makefile
  makefile_path=$(find "$current_release" -name 'Makefile' | head -n 1)
  if [ -z "$makefile_path" ]; then
    echo "❌ Error: No Makefile found in the last release."
    exit 1
  fi

  # Ask user to run make
  echo "Makefile found at: $makefile_path"
  read -p "Do you want to run 'make' in this directory? (y/n): " choice
  if [ "$choice" = "y" ]; then
    make -C "$(dirname "$makefile_path")"
  else
    echo "Build cancelled."
  fi
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
  build)
    build_last_release
    ;;
    -b)
    build_last_release
    ;;
  *)
    echo "Usage: $0 {deploy|rollback|build}"
    exit 1
    ;;
esac