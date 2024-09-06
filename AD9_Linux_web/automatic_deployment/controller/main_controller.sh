#!/bin/bash

main() {
    local keep_releases=$DEFAULT_KEEP_RELEASES
    local command=""

    # Vérification des prérequis
    check_prerequisites

    # Traitement des options
    while getopts ":k:r:b:f:m" opt; do
        case ${opt} in
            k ) keep_releases=$OPTARG ;;
            r ) GIT_REPO=$OPTARG ;;
            b ) GIT_BRANCH=$OPTARG ;;
            f ) GIT_FOLDER=$OPTARG ;;
            m ) man_controller; exit 0 ;;
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
        man) man_controller ;;
        *) print_usage; exit 1 ;;
    esac
}

man_controller() {
    generate_man_page | less -R
}

check_prerequisites() {
    command -v realpath >/dev/null 2>&1 || { print_error "realpath est requis mais n'est pas installé. Abandon."; exit 1; }
    command -v git >/dev/null 2>&1 || { print_error "git est requis mais n'est pas installé. Abandon."; exit 1; }
    command -v less >/dev/null 2>&1 || { print_error "less est requis mais n'est pas installé. Abandon."; exit 1; }
}

print_usage() {
    echo "Usage: $0 [-k nombre_de_releases] [-r repo_git] [-b branche_git] [-f dossier_git] [-m] {deploy|rollback|man}"
    echo "  -m: Afficher la page de manuel"
    echo "  man: Afficher la page de manuel"
}