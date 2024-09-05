#!/bin/bash

# Deployment script

# Set the project root directory
PROJECT_ROOT="./project"

# Default number of releases to keep
KEEP_RELEASES=5

# Function to get current timestamp
get_timestamp() {
    date +"%Y%m%d%H%M%S"
}

# Function to create symlinks for shared files
create_shared_symlinks() {
    local release_dir="$1"
    if [ -d "$PROJECT_ROOT/shared" ]; then
        echo "Creating symlinks for shared files..."
        for file in "$PROJECT_ROOT/shared"/*; do
            if [ -e "$file" ]; then
                ln -s "$(realpath "$file")" "$release_dir/$(basename "$file")"
            fi
        done
    else
        echo "Shared directory not found. Skipping symlink creation."
    fi
}

# Function to cleanup old releases
cleanup_old_releases() {
    local releases_to_keep=$1
    echo "Cleaning up old releases, keeping last $releases_to_keep..."
    cd "$PROJECT_ROOT/releases" || exit
    ls -1td */ | tail -n +$((releases_to_keep + 1)) | while read -r dir; do
        rm -rf "$dir"
    done
    cd - > /dev/null || exit
}

# Main deployment function
deploy() {
    local timestamp=$(get_timestamp)
    local release_dir="$PROJECT_ROOT/releases/$timestamp"

    # Create the new release directory
    mkdir -p "$release_dir"
    echo "Created new release directory: $release_dir"

    # Create symlinks for shared files
    create_shared_symlinks "$release_dir"

    # Update the 'current' symlink
    ln -sfn "$(realpath "$release_dir")" "$PROJECT_ROOT/current"
    echo "Updated 'current' symlink to point to the new release."

    # Cleanup old releases
    cleanup_old_releases "$KEEP_RELEASES"
}

# Rollback function
rollback() {
    echo "Rolling back to the previous release..."
    local current_release=$(readlink "$PROJECT_ROOT/current")
    local previous_release=$(ls -1td "$PROJECT_ROOT"/releases/*/ | sed -n '2p')

    if [ -z "$previous_release" ]; then
        echo "No previous release found. Cannot rollback."
        exit 1
    fi

    ln -sfn "$(realpath "$previous_release")" "$PROJECT_ROOT/current"
    echo "Rolled back to: $previous_release"
}

# Parse command line options
while getopts ":k:" opt; do
  case $opt in
    k) KEEP_RELEASES="$OPTARG"
    ;;
    \?) echo "Invalid option -$OPTARG" >&2
    exit 1
    ;;
  esac
done

shift $((OPTIND-1))

# Main script execution
case "$1" in
    deploy)
        deploy
        ;;
    rollback)
        rollback
        ;;
    *)
        echo "Usage: $0 [-k num_releases_to_keep] {deploy|rollback}"
        exit 1
        ;;
esac
