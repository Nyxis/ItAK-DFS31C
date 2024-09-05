#!/bin/bash

# Load environment variables
if [ -f .env ]; then
    source .env
fi

# Default values (can be overridden by .env file)
GIT_REPO=${GIT_REPO:-"https://github.com/Nyxis/ItAK-DFS31C.git"}
GIT_BRANCH=${GIT_BRANCH:-"main"}
GIT_SUBDIRECTORY=${GIT_SUBDIRECTORY:-"clone_me"}

# Set the project root directory
PROJECT_ROOT="./project"

# Default number of releases to keep
KEEP_RELEASES=${KEEP_RELEASES:-5}

# Function to get current timestamp
get_timestamp() {
    date +"%Y%m%d%H%M%S"
}

# Function to check if git is available
check_git() {
    if ! command -v git &> /dev/null; then
        echo "Git is not installed or not in PATH. Please install git and try again."
        exit 1
    fi
}

# Function to clone repository
clone_repo() {
    local release_dir=$1

    # Remove temp_clone if it exists
    rm -rf temp_clone

    echo "Cloning repository: $GIT_REPO (branch: $GIT_BRANCH)"
    if git clone -b "$GIT_BRANCH" "$GIT_REPO" temp_clone; then
        if [ -d "temp_clone/$GIT_SUBDIRECTORY" ]; then
            echo "Moving contents of $GIT_SUBDIRECTORY to $release_dir"
            mv "temp_clone/$GIT_SUBDIRECTORY"/* "$release_dir/"
        elif [ "$GIT_SUBDIRECTORY" = "." ]; then
            echo "Moving all contents to $release_dir"
            mv temp_clone/* "$release_dir/"
        else
            echo "Specified subdirectory '$GIT_SUBDIRECTORY' not found in the repository."
            echo "Available directories:"
            ls -R temp_clone
            rm -rf temp_clone
            exit 1
        fi
    else
        echo "Failed to clone repository"
        exit 1
    fi

    # Clean up
    rm -rf temp_clone
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
    check_git

    local timestamp=$(get_timestamp)
    local release_dir="$PROJECT_ROOT/releases/$timestamp"

    # Create the new release directory
    mkdir -p "$release_dir"
    echo "Created new release directory: $release_dir"

    # Clone the repository
    clone_repo "$release_dir"

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
while getopts ":k:r:b:d:" opt; do
  case $opt in
    k) KEEP_RELEASES="$OPTARG" ;;
    r) GIT_REPO="$OPTARG" ;;
    b) GIT_BRANCH="$OPTARG" ;;
    d) GIT_SUBDIRECTORY="$OPTARG" ;;
    \?) echo "Invalid option -$OPTARG" >&2; exit 1 ;;
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
        echo "Usage: $0 [-k num_releases] [-r repo_url] [-b branch] [-d subdirectory] {deploy|rollback}"
        exit 1
        ;;
esac
