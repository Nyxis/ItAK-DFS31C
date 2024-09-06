#!/bin/bash

# Configuration file path
config_file=".env"

# Load configurations
if [ -f "$config_file" ]; then
    source "$config_file"
else
    # Default value if configuration file does not exist
    keepReleases=5
fi

# Function to save current configurations
save_config() {
    echo "keepReleases=$keepReleases" > "$config_file"
}

# Define base directories
releases_dir="project/releases"
release_dir="project/current/release"  # Directory for the actual 'current' directory, not just a symlink
shared_dir="project/shared"
dev_dir="project/dev"

# Ensure the required directories exist
mkdir -p "$releases_dir" "$release_dir" "$shared_dir" "$dev_dir"

# Function to update the 'current' directory to the latest release
update_current() {
    local new_release_path="$1"
    local release_name=$(basename "$new_release_path")

    # Check if current link exists and move it to releases before updating
    if [ -L "$release_dir/current" ]; then
        local old_release_path=$(readlink "$release_dir/current")
        local old_release_name=$(basename "$old_release_path")
        mv "$old_release_path" "$releases_dir/$old_release_name"
        echo "Moved old release $old_release_name to releases directory."
    fi

    # Update 'current' directory
    ln -sfn "$new_release_path" "$release_dir/current"
    echo "Current release set to: $release_name"
}

# Deployment logic
deploy() {
    local timestamp=$(date +"%Y%m%d%H%M%S")
    local new_release_dir="$release_dir/$timestamp"
    mkdir -p "$new_release_dir"
    find "$dev_dir" -type f -print0 | while IFS= read -r -d '' file; do
        local subdir=$(dirname "${file#$dev_dir/}")
        mkdir -p "$new_release_dir/$subdir"
        ln -s "$PWD/$file" "$new_release_dir/$subdir/$(basename "$file")"
    done
    update_current "$new_release_dir"
    echo "Deployment complete: $timestamp"
}

# Rollback logic
# Rollback logic
rollback() {
    # Fetch all available releases sorted from newest to oldest
    local releases=($(ls -1t "$releases_dir"))
    
    # Ensure there's at least one older release to rollback to
    if [ ${#releases[@]} -eq 0 ]; then
        echo "Rollback not possible: No older releases available."
        return 1
    fi
    
    # Resolve the symlink to find the currently active release
    local current_release=$(basename "$(readlink "$release_dir/current")")
    local next_release="${releases[0]}"  # The most recent in releases_dir

    # Check if the current release is already the oldest available
    if [[ "$current_release" == "$next_release" ]]; then
        echo "Rollback not possible: Current release is the only release or the newest available."
        return 1
    fi

    # Prepare for the rollback by removing the current directory and moving the old release
    echo "Rolling back from $current_release to $next_release."
    rm -rf "$release_dir/$current_release"  # Remove the actual current directory, if it exists physically in release_dir
    mv "$releases_dir/$next_release" "$release_dir/"  # Move the next most recent release to current directory

    # Update the current symlink to point to the newly moved release
    ln -sfn "$release_dir/$next_release" "$release_dir/current"
    echo "Rollback to $next_release completed successfully."
}

# Read options
while getopts ":k:" opt; do
  case ${opt} in
    k )
        keepReleases=$OPTARG
        save_config
        ;;
    \? )
        echo "Invalid option: -$OPTARG" >&2
        exit 1
        ;;
  esac
done

shift $((OPTIND-1))

# Process commands
case "$1" in
    deploy)
        deploy
        ;;
    rollback)
        rollback
        ;;
    *)
        echo "Usage: $0 {deploy|rollback} [-k number_of_releases]"
        exit 1
        ;;
esac

# Cleanup old releases
cd "$releases_dir"
ls -1 | sort -r | tail -n +$((keepReleases + 1)) | xargs -r rm -rf
echo "Old releases cleaned up, keeping the last $keepReleases."