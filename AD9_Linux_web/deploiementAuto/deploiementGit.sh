#!/bin/bash

# Configuration file path
config_file=".env"
verbose=false  # Initialize verbose logging as false
noInteraction=false  # Initialize no-interaction mode as false
quiet=false  # Initialize quiet mode as false

# Test if git is installed
if ! command -v git &> /dev/null; then
    echo "Git is required but not installed. Abort deployment."
    exit 1
fi

# Load configurations
if [ -f "$config_file" ]; then
    source "$config_file"
else
    keepReleases=5
    distantRepository="https://github.com/Nyxis/ItAK-DFS31C.git"
    repositoryBranch="main"
    repositoryFolder="clone_me"
fi

# Function to save current configurations
save_config() {
    echo "keepReleases=$keepReleases" > "$config_file"
    echo "distantRepository=$distantRepository" >> "$config_file"
    echo "repositoryBranch=$repositoryBranch" >> "$config_file"
    echo "repositoryFolder=$repositoryFolder" >> "$config_file"
}

# Define base directories
releases_dir="project/releases"
release_dir="project/current/release"
shared_dir="project/shared"

mkdir -p "$releases_dir" "$release_dir" "$shared_dir"

display_help() {
    echo "Usage: $0 {deploy|rollback} [options]"
    echo "Options:"
    echo "  -k <num>         Specify the number of releases to keep."
    echo "  -b <command>     Specify a custom build command."
    echo "  -h, --help       Show this help message and exit."
    echo "  -v, --verbose    Enable verbose mode."
    echo "  -V, --version    Show version information and exit."
    exit 0
}

clone_repository() {
    local timestamp="$1"
    git clone -b "$repositoryBranch" "$distantRepository" "$release_dir/$timestamp"
    [ "$verbose" = true ] && echo "Repository cloned into $release_dir/$timestamp"
}

# Function to perform build operations and handle failures
build() {
    local build_directory="$release_dir/$timestamp"
    cd "$build_directory"
    
    # Check if a build command is defined
    if [ -n "$buildCommand" ]; then
        if [ "$quiet" = false ]; then echo "Building project with custom command..."; fi
        if ! eval "$buildCommand"; then
            if [ "$quiet" = false ]; then echo "Build failed. Initiating rollback..."; fi
            rollback
            exit 1
        fi
        if [ "$quiet" = false ]; then echo "Build successful."; fi
    elif [ -f "Makefile" ]; then
        if [ "$quiet" = false ]; then echo "Makefile found but no build command defined. Execute 'make' (Y/n)?"; fi
        if [ "$noInteraction" = false ]; then
            read -r execute_make
            if [[ "$execute_make" == "Y" || "$execute_make" == "y" ]]; then
                if [ "$quiet" = false ]; then echo "Executing 'make'..."; fi
                if ! make; then
                    if [ "$quiet" = false ]; then echo "Make failed. Initiating rollback..."; fi
                    rollback
                    exit 1
                fi
                if [ "$quiet" = false ]; then echo "Make successful."; fi
            else
                if [ "$quiet" = false ]; then echo "Skipping 'make'."; fi
            fi
        else
            if [ "$quiet" = false ]; then echo "Non-interactive mode: Auto-executing 'make'..."; fi
            if ! make; then
                if [ "$quiet" = false ]; then echo "Make failed in non-interactive mode. Initiating rollback..."; fi
                rollback
                exit 1
            fi
            if [ "$quiet" = false ]; then echo "Make executed successfully in non-interactive mode."; fi
        fi
    else
        if [ "$quiet" = false ]; then echo "No build command defined and no Makefile found. Skipping build step."; fi
    fi
}

update_current() {
    local new_release_path="$1"
    local release_name=$(basename "$new_release_path")
    if [ -L "$release_dir/current" ]; then
        local old_release_path=$(readlink "$release_dir/current")
        local old_release_name=$(basename "$old_release_path")
        mv "$old_release_path" "$releases_dir/$old_release_name"
        echo "Moved old release $old_release_name to releases directory."
    fi
    ln -sfn "$new_release_path" "$release_dir/current"
    echo "Current release set to: $release_name"
}

deploy() {
    local timestamp=$(date +"%Y%m%d%H%M%S")
    local new_release_dir="$release_dir/$timestamp"
    mkdir -p "$new_release_dir"
    clone_repository "$timestamp"
    if [ -n "$buildCommand" ]; then
        build
    fi
    update_current "$new_release_dir"
    echo "Deployment complete: $timestamp"
}

rollback() {
    local releases=($(ls -1t "$releases_dir"))
    if [ ${#releases[@]} -eq 0 ]; then
        echo "Rollback not possible: No older releases available."
        return 1
    fi
    local current_release=$(basename "$(readlink "$release_dir/current")")
    local next_release="${releases[0]}"
    if [[ "$current_release" == "$next_release" ]]; then
        echo "Rollback not possible: Current release is the only release or the newest available."
        return 1
    fi
    echo "Rolling back from $current_release to $next_release."
    rm -rf "$release_dir/$current_release"
    mv "$releases_dir/$next_release" "$release_dir/"
    ln -sfn "$release_dir/$next_release" "$release_dir/current"
    echo "Rollback to $next_release completed successfully."
}

while getopts ":k:b:hvV" opt; do
    case "$opt" in
        k)
            keepReleases=$OPTARG
            save_config
            ;;
        b)
            buildCommand=$OPTARG
            ;;
        h)
            display_help
            ;;
        v)
            verbose=true
            ;;
        q)
            quiet=true
            ;;
        n)
            noInteraction=true
            ;;
        V)
            echo "Version 1.0"
            exit 0
            ;;
        \?)
            if [ "$quiet" = false ]; then
                echo "Invalid option: -$OPTARG" >&2
            fi
            exit 1
            ;;
    esac
done

for arg in "$@"; do
    case "$arg" in
        --help)
            display_help
            ;;
        --verbose)
            verbose=true
            ;;
        --quiet)
            quiet=true
            ;;
        --no-interaction)
            noInteraction=true
            ;;
        --version)
            echo "Version 1.0"
            exit 0
            ;;
    esac
done

case "$1" in
    deploy)
        deploy
        ;;
    rollback)
        rollback
        ;;
    *)
        echo "Usage: $0 {deploy|rollback} [-k number_of_releases] [-b build_command]"
        exit 1
        ;;
esac

cd "$releases_dir"
ls -1 | sort -r | tail -n +$((keepReleases + 1)) | xargs -r rm -rf
echo "Old releases cleaned up, keeping the last $keepReleases."