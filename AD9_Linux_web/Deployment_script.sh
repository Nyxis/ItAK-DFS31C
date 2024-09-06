#!/bin/bash

# Version
VERSION="1.0.0"

# Load environment variables
if [ -f .env ]; then
    source .env
fi

# Default values (can be overridden by .env file)
GIT_REPO=${GIT_REPO:-"https://github.com/Nyxis/ItAK-DFS31C.git"}
GIT_BRANCH=${GIT_BRANCH:-"main"}
GIT_SUBDIRECTORY=${GIT_SUBDIRECTORY:-"clone_me"}
PROJECT_ROOT="./project"
KEEP_RELEASES=${KEEP_RELEASES:-5}
BUILD_COMMAND=""
ROLLBACK_COMMAND=""
VERBOSE=false
QUIET=false
NO_INTERACTION=false

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
    rm -rf temp_clone
    $VERBOSE && echo "Cloning repository: $GIT_REPO (branch: $GIT_BRANCH)"
    if git clone -b "$GIT_BRANCH" "$GIT_REPO" temp_clone; then
        if [ -d "temp_clone/$GIT_SUBDIRECTORY" ]; then
            $VERBOSE && echo "Moving contents of $GIT_SUBDIRECTORY to $release_dir"
            mv "temp_clone/$GIT_SUBDIRECTORY"/* "$release_dir/"
        elif [ "$GIT_SUBDIRECTORY" = "." ]; then
            $VERBOSE && echo "Moving all contents to $release_dir"
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
    rm -rf temp_clone
}

# Function to create symlinks for shared files
create_shared_symlinks() {
    local release_dir="$1"
    if [ -d "$PROJECT_ROOT/shared" ]; then
        $VERBOSE && echo "Creating symlinks for shared files..."
        for file in "$PROJECT_ROOT/shared"/*; do
            if [ -e "$file" ]; then
                ln -s "$(realpath "$file")" "$release_dir/$(basename "$file")"
            fi
        done
    else
        $VERBOSE && echo "Shared directory not found. Skipping symlink creation."
    fi
}

# Function to cleanup old releases
cleanup_old_releases() {
    local releases_to_keep=$1
    $VERBOSE && echo "Cleaning up old releases, keeping last $releases_to_keep..."
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
    mkdir -p "$release_dir"
    $VERBOSE && echo "Created new release directory: $release_dir"
    clone_repo "$release_dir"
    create_shared_symlinks "$release_dir"

    # Build step
    if [ -n "$BUILD_COMMAND" ]; then
        $VERBOSE && echo "Executing build command: $BUILD_COMMAND"
        if ! eval "$BUILD_COMMAND"; then
            echo "Build failed. Stopping deployment."
            exit 1
        fi
    elif [ -f "$release_dir/Makefile" ]; then
        if $NO_INTERACTION; then
            $VERBOSE && echo "Makefile detected. Running 'make' (non-interactive mode)."
            if ! make -C "$release_dir"; then
                echo "Make failed. Stopping deployment."
                exit 1
            fi
        else
            read -p "Makefile detected. Run 'make'? (Y/n) " -n 1 -r
            echo
            if [[ $REPLY =~ ^[Yy]$ ]] || [[ -z $REPLY ]]; then
                if ! make -C "$release_dir"; then
                    echo "Make failed. Stopping deployment."
                    exit 1
                fi
            fi
        fi
    fi

    ln -sfn "$(realpath "$release_dir")" "$PROJECT_ROOT/current"
    $VERBOSE && echo "Updated 'current' symlink to point to the new release."
    cleanup_old_releases "$KEEP_RELEASES"
}

# Rollback function
rollback() {
    $VERBOSE && echo "Rolling back to the previous release..."
    local current_release=$(readlink "$PROJECT_ROOT/current")
    local previous_release=$(ls -1td "$PROJECT_ROOT"/releases/*/ | sed -n '2p')

    if [ -z "$previous_release" ]; then
        echo "No previous release found. Cannot rollback."
        exit 1
    fi

    ln -sfn "$(realpath "$previous_release")" "$PROJECT_ROOT/current"
    $VERBOSE && echo "Rolled back to: $previous_release"

    if [ -n "$ROLLBACK_COMMAND" ]; then
        $VERBOSE && echo "Executing rollback command: $ROLLBACK_COMMAND"
        if ! eval "$ROLLBACK_COMMAND"; then
            echo "Rollback command failed."
            exit 1
        fi
    fi
}

# Function to display help
display_help() {
    echo "Usage: $0 [OPTIONS] {deploy|rollback}"
    echo "Options:"
    echo "  -k NUM      Number of releases to keep (default: 5)"
    echo "  -r URL      Git repository URL"
    echo "  -b BRANCH   Git branch to use"
    echo "  -d DIR      Subdirectory in the repository to deploy"
    echo "  -B CMD      Build command to execute"
    echo "  -R CMD      Rollback command to execute"
    echo "  -h, --help  Display this help message"
    echo "  -v, --verbose  Display debug messages"
    echo "  -q, --quiet    Disable all output except prompts"
    echo "  -n, --no-interaction  Disable prompts (use default answers)"
    echo "  -V, --version  Display script version"
}

# Parse command line options
while [[ $# -gt 0 ]]; do
    case $1 in
        -k) KEEP_RELEASES="$2"; shift 2 ;;
        -r) GIT_REPO="$2"; shift 2 ;;
        -b) GIT_BRANCH="$2"; shift 2 ;;
        -d) GIT_SUBDIRECTORY="$2"; shift 2 ;;
        -B) BUILD_COMMAND="$2"; shift 2 ;;
        -R) ROLLBACK_COMMAND="$2"; shift 2 ;;
        -h|--help) display_help; exit 0 ;;
        -v|--verbose) VERBOSE=true; shift ;;
        -q|--quiet) QUIET=true; shift ;;
        -n|--no-interaction) NO_INTERACTION=true; shift ;;
        -V|--version) echo "Version $VERSION"; exit 0 ;;
        deploy|rollback) ACTION=$1; shift ;;
        *) echo "Unknown option: $1" >&2; exit 1 ;;
    esac
done

# Main script execution
if $QUIET; then
    exec 3>&1 4>&2
    exec 1>/dev/null 2>&1
fi

case "$ACTION" in
    deploy)
        deploy
        ;;
    rollback)
        rollback
        ;;
    *)
        echo "Usage: $0 [OPTIONS] {deploy|rollback}"
        exit 1
        ;;
esac

if $QUIET; then
    exec 1>&3 2>&4
fi
