#!/bin/bash

# Deployment script

# Set the project root directory
PROJECT_ROOT="./project"

# Create the basic directory structure
mkdir -p "$PROJECT_ROOT/releases"
mkdir -p "$PROJECT_ROOT/shared"

# Function to get current timestamp
get_timestamp() {
    date +"%Y%m%d%H%M%S"
}

# Main deployment function
deploy() {
    local timestamp=$(get_timestamp)
    local release_dir="$PROJECT_ROOT/releases/$timestamp"

    # Create the new release directory
    mkdir -p "$release_dir"

    echo "Created new release directory: $release_dir"

    # Copy files from shared directory
    if [ -d "$PROJECT_ROOT/shared" ]; then
        echo "Copying files from shared directory..."
        cp -R "$PROJECT_ROOT/shared"/* "$release_dir/"
    else
        echo "Shared directory not found. Skipping file copy."
    fi

    # Update the 'current' symlink
    ln -sfn "$release_dir" "$PROJECT_ROOT/current"
    echo "Updated 'current' symlink to point to the new release."
}

# Main script execution
deploy
