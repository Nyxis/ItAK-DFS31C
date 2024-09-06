#!/bin/bash

# Chargement des variables d'environnement
load_environment() {
    if [ -f .env ]; then
        source .env
    fi

    export PROJECT_ROOT=${PROJECT_ROOT:-$(realpath "./project")}
    export RELEASES_DIR="${PROJECT_ROOT}/releases"
    export SHARED_DIR="${PROJECT_ROOT}/shared"
    export CURRENT_LINK="${PROJECT_ROOT}/current"
    export DEFAULT_KEEP_RELEASES=${DEFAULT_KEEP_RELEASES:-5}
    export GIT_REPO=${GIT_REPO:-""}
    export GIT_BRANCH=${GIT_BRANCH:-""}
    export GIT_FOLDER=${GIT_FOLDER:-""}
}