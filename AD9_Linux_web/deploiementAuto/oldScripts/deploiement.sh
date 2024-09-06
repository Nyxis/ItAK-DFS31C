#!/bin/bash

# Load configuration from the environment file
load_config() {
    if [ -f "$config_file" ]; then
        source "$config_file"
    else
        echo "Configuration file not found. Using default settings."
        keepReleases=5
        distantRepository="https://github.com/Nyxis/ItAK-DFS31C.git"
        repositoryBranch="main"
        repositoryFolder="clone_me"
    fi
}

# Save configuration to the environment file
save_config() {
    echo "keepReleases=$keepReleases" > "$config_file"
    echo "distantRepository=$distantRepository" >> "$config_file"
    echo "repositoryBranch=$repositoryBranch" >> "$config_file"
    echo "repositoryFolder=$repositoryFolder" >> "$config_file"
}

# Display usage information and exit
display_help() {
    echo "Usage: $0 {deploy|rollback} [options]"
    echo "Options:"
    echo "  -k <num>       Specify the number of releases to keep."
    echo "  -b <command>   Specify a custom build command."
    echo "  -h, --help     Show this help message and exit."
    echo "  -V, --version  Show version information and exit."
    exit 0
}

# Clone the repository into a new release directory
clone_repository() {
    local timestamp=$(date +"%Y%m%d%H%M%S")
    local new_release_dir="$release_dir/$timestamp"
    mkdir -p "$new_release_dir"
    echo "Cloning repository..."
    git clone -b "$repositoryBranch" "$distantRepository" "$new_release_dir"
    echo "Repository cloned."
    return "$new_release_dir"
}

# Handle build process within the cloned directory
handle_build() {
    local build_directory=$1
    cd "$build_directory"
    if [ -n "$buildCommand" ]; then
        echo "Executing build command..."
        if ! eval "$buildCommand"; then
            echo "Build failed."
            return 1
        fi
        echo "Build successful."
    elif [ -f "Makefile" ]; then
        echo "Makefile found. Execute 'make' (Y/n)?"
        read -r execute_make
        [[ "$execute_make" =~ ^[Yy]$ ]] && make || echo "Skipping 'make'."
    else
        echo "No build steps defined."
    fi
    return 0
}

# Update the 'current' directory to point to the latest release
update_current() {
    local new_release_path=$1
    if [ -L "$release_dir" ]; then
        local old_release=$(readlink "$release_dir")
        mv "$old_release" "$releases_dir/"
        echo "Old release moved to archive."
    fi
    ln -sfn "$new_release_path" "$release_dir"
    echo "Current release set to: $(basename "$new_release_path")."
}

# Deployment logic including repository cloning and build handling
deploy() {
    local new_release_dir=$(clone_repository)
    if ! handle_build "$new_release_dir"; then
        rollback
        exit 1
    fi
    update_current "$new_release_dir"
    echo "Deployment complete."
}

# Rollback to the most recent release in the archive
rollback() {
    local last_release=$(ls -1t "$releases_dir" | head -n 1)
    if [ -z "$last_release" ]; then
        echo "No older releases available for rollback."
        return
    fi
    update_current "$$last_release"
    echo "Rolled back to $last_release."
}

# Main script execution logic
main() {
    while getopts ":k:b:hV" opt; do
        case $opt in
            k) keepReleases=$OPTARG; save_config ;;
            b) buildCommand=$OPTARG ;;
            h) display_help ;;
            V) echo "Version 1.0"; exit ;;
            ?) echo "Invalid option: -$OPTARG"; exit 1 ;;
        esac
    done

# This manually checks for long options after getopts has finished
shift $((OPTIND-1))
for arg in "$@"; do
  case "$arg" in
    --help)
      display_help
      ;;
    --version)
      echo "Version 1.0"
      exit 0
      ;;
    *)
      # Handle unexpected options
      if [[ "$arg" == --* ]]; then
        echo "Illegal option $arg"
        exit 1
      fi
      ;;
  esac
done

    case "$1" in
        deploy) deploy ;;
        rollback) rollback ;;
        *) display_help ;;
    esac

    # Cleanup old releases
    find "$releases_dir" -mindepth 1 -maxdepth 1 -type d | sort -r | tail -n +$((keepReleases + 1)) | xargs rm -rf
    echo "Old releases cleaned up, keeping the last $keepReleases."
}

# Configuration and base variables
config_file=".env"
releases_dir="project/releases"
release_dir="project/current/release"
shared_dir="project/shared"

load_config
main "$@"