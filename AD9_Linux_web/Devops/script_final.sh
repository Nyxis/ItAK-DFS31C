#!/bin/bash

# Function to display help
show_help() {
    echo "Usage: $0 [OPTIONS] COMMAND"
    echo "Commands:"
    echo "  deploy    Deploy a new version"
    echo "  rollback  Revert to the previous version"
    echo "Options:"
    echo "  -k NUMBER  Number of releases to keep (default: 5)"
    echo "  -h         Display this help"
}

# Function to get current date
get_current_date() {
    date +"%Y%m%d%H%M%S"
}

# Function to create example shared structure
create_shared_structure() {
    mkdir -p project/shared/lib
    echo "Example config content" > project/shared/mysupersecretproductionconfigfile.yaml
    echo "Example library content" > project/shared/lib/thecompanylegacynotversionnedlibrary
    echo "Example shared structure created."
}

# Function to create symbolic links
create_symlinks() {
    local release_folder="project/releases/$1"
    for file in $(find project/shared -type f); do
        local relative_path=${file#project/shared/}
        local target_dir="$release_folder/$(dirname "$relative_path")"
        mkdir -p "$target_dir"
        ln -s "$file" "$release_folder/$relative_path"
    done
    echo "Symbolic links created for shared files."
}

# Function to update "current" link
update_current_link() {
    ln -sfn "releases/$1" project/current
    echo "'current' link updated to $1"
}

# Function to check and create necessary structure
check_and_create_structure() {
    if [ ! -d "project/shared" ] || [ ! -d "project/releases" ]; then
        echo "Creating necessary directory structure..."
        mkdir -p project/shared project/releases
        create_shared_structure
    fi
}

# Function to perform rollback
do_rollback() {
    echo "Performing rollback..."
    
    # Check if the project structure exists
    if [ ! -d "project/releases" ] || [ ! -L "project/current" ]; then
        echo "Error: Project structure not found. Make sure you have deployed at least once."
        exit 1
    fi

    # Get the current release
    current_release=$(readlink project/current)
    current_release=$(basename "$current_release")

    # Get the list of all releases sorted by date (newest first)
    releases=($(ls -1t project/releases))

    # Find the index of the current release
    current_index=-1
    for i in "${!releases[@]}"; do
        if [[ "${releases[$i]}" = "${current_release}" ]]; then
            current_index=$i
            break
        fi
    done

    # Check if we can rollback
    if [ $current_index -eq -1 ] || [ $current_index -eq $((${#releases[@]} - 1)) ]; then
        echo "Unable to perform rollback. No previous version found."
        exit 1
    fi

    # Get the previous release
    previous_release="${releases[$((current_index + 1))]}"

    # Update the current link
    update_current_link "$previous_release"
    echo "Rollback performed to $previous_release"
}

# Initialize variables
keep_releases=5
command=""

# Process command line options
while getopts "k:h" opt; do
    case $opt in
        k) keep_releases=$OPTARG ;;
        h) show_help; exit 0 ;;
        ?) show_help; exit 1 ;;
    esac
done

# Get command
shift $((OPTIND - 1))
command=$1

# Execute appropriate command
case $command in
    deploy)
        echo "Deploying new version..."
        check_and_create_structure
        current_date=$(get_current_date)
        echo "Current date: $current_date"
        mkdir -p "project/releases/$current_date"
        echo "Release folder created: project/releases/$current_date"
        create_symlinks $current_date
        update_current_link $current_date
        
        echo "Cleaning old releases..."
        cd project/releases
        ls -1t | tail -n +$((keep_releases + 1)) | xargs -r rm -rf
        echo "Keeping last $keep_releases releases."
        ;;
    rollback)
        do_rollback
        ;;
    *)
        echo "Invalid command: $command"
        show_help
        exit 1
        ;;
esac

echo "Operation completed successfully!"
exit 0