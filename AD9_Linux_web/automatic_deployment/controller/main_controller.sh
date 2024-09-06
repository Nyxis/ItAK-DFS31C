#!/bin/bash

main() {
    local keep_releases=$DEFAULT_KEEP_RELEASES
    local command=""

    # Vérification des prérequis
    check_prerequisites

    # Traitement des options
    while getopts ":k:r:b:f:" opt; do
        case ${opt} in
            k ) keep_releases=$OPTARG ;;
            r ) GIT_REPO=$OPTARG ;;
            b ) GIT_BRANCH=$OPTARG ;;
            f ) GIT_FOLDER=$OPTARG ;;
            \? ) print_error "Option invalide : -$OPTARG"; exit 1 ;;
            : ) print_error "L'option -$OPTARG requiert un argument."; exit 1 ;;
        esac
    done
    shift $((OPTIND -1))

    # Récupération de la commande
    command=$1

    case $command in
        deploy) deploy_controller $keep_releases ;;
        rollback) rollback_controller ;;
        *) print_usage; exit 1 ;;
    esac
}

check_prerequisites() {
    command -v realpath >/dev/null 2>&1 || { print_error "realpath est requis mais n'est pas installé. Abandon."; exit 1; }
    command -v git >/dev/null 2>&1 || { print_error "git est requis mais n'est pas installé. Abandon."; exit 1; }
}