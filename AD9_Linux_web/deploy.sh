#!/bin/bash

# Charger les variables d'environnement
if [ -f .env ]; then
  source .env
else
  echo "❌ Error: .env file not found!"
  exit 1
fi

# Check if git command is available
if ! command -v git &> /dev/null; then
  echo "❌ Error: git command not found."
  exit 1
fi

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

  # Initialize a new git repository
  git init "$release_dir/$new_folder"
  cd "$release_dir/$new_folder"

  # Set the remote repository
  git remote add origin "$GIT_REPO"

  # Enable sparse checkout
  git config core.sparseCheckout true

  # Specify the folder to checkout
  echo "$GIT_DIR/" >> .git/info/sparse-checkout

  # Pull the specified branch
  git pull origin "$GIT_BRANCH"
  if [ $? -ne 0 ]; then
    echo "❌ Error: Failed to pull repository: $GIT_REPO"
    exit 1
  fi
  echo "✅ Pulled repository: $GIT_REPO"

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
      fi
    done
  fi
}

# Function to rollback to a previous release
rollback() {
  # Implement rollback logic here
  echo "🔄 Rolling back to previous release..."
  # Example: Remove the latest release directory
  latest_release=$(ls -td "$release_dir"/* | head -1)
  if [ -d "$latest_release" ]; then
    rm -rf "$latest_release"
    echo "✅ Rolled back: Removed $latest_release"
  else
    echo "❌ Error: No release found to rollback."
    exit 1
  fi
}

# Parse the command
case "$1" in
  deploy|-d)
    deploy
    ;;
  rollback|-r)
    rollback
    ;;
  *)
    echo "Usage: $0 {deploy|rollback}"
    exit 1
    ;;
esac