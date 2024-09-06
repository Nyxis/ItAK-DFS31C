#!/bin/bash

clone_repository() {
    local temp_dir=$(mktemp -d)
    git clone --branch "$GIT_BRANCH" "$GIT_REPO" "$temp_dir" || return 1
    echo "$temp_dir"
}

move_repository_contents() {
    local temp_dir="$1"
    local release_dir="$2"
    
    if [ -n "$GIT_FOLDER" ]; then
        if [ -d "$temp_dir/$GIT_FOLDER" ]; then
            mkdir -p "$release_dir"
            mv "$temp_dir/$GIT_FOLDER"/* "$release_dir/" || return 1
        else
            echo "Le dossier spécifié $GIT_FOLDER n'existe pas dans le dépôt" >&2
            return 1
        fi
    else
        mv "$temp_dir" "$release_dir" || return 1
    fi
    
    [ -d "$temp_dir" ] && rm -rf "$temp_dir"
    return 0
}