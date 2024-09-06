#!/bin/bash

# Version du script
VERSION="1.0.0"

# Chargement des variables d'environnement
if [ -f .env ]; then
    source .env
fi

# Valeurs par défaut
GIT_REPO=${GIT_REPO:-"https://github.com/YacineBoukliff/ItAK-DFS31C.git"}
GIT_BRANCH=${GIT_BRANCH:-"main"}
GIT_FOLDER=${GIT_FOLDER:-"."}
KEEP_RELEASES=${KEEP_RELEASES:-5}
BUILD_COMMAND=${BUILD_COMMAND:-""}
ROLLBACK_COMMAND=${ROLLBACK_COMMAND:-""}

# Options
VERBOSE=false
QUIET=false
NO_INTERACTION=false

# Fonction pour obtenir la date au format YYYYMMDDHHmmss
get_date() {
    date +%Y%m%d%H%M%S
}

# Fonction pour afficher les messages en mode verbose
log() {
    if [ "$VERBOSE" = true ] && [ "$QUIET" = false ]; then
        echo "$@"
    fi
}

# Fonction pour créer la structure de dossiers
create_structure() {
    mkdir -p project/releases project/shared
    log "Structure de dossiers créée"
}

# Fonction pour créer une nouvelle release
create_release() {
    local date=$(get_date)
    mkdir -p "project/releases/$date"
    log "Nouvelle release créée : $date"
    
    # Copier ou lier les fichiers partagés
    find project/shared -type f -exec ln -s "$(pwd)/{}" "project/releases/$date/{}" \;
    log "Fichiers partagés liés"
    
    # Mettre à jour le lien 'current'
    ln -sfn "$(pwd)/project/releases/$date" project/current
    log "Lien 'current' mis à jour"
}

# Fonction pour nettoyer les anciennes releases
cleanup_releases() {
    local keep=$1
    cd project/releases
    ls -t | tail -n +$((keep + 1)) | xargs rm -rf
    cd ../..
    log "Nettoyage des anciennes releases effectué, gardant les $keep dernières"
}

# Fonction pour effectuer un rollback
rollback() {
    local current_release=$(readlink project/current)
    local previous_release=$(ls -t project/releases | sed -n 2p)
    
    if [ -z "$previous_release" ]; then
        echo "Aucune release précédente disponible pour le rollback."
        exit 1
    fi
    
    ln -sfn "$(pwd)/project/releases/$previous_release" project/current
    log "Rollback effectué vers la release : $previous_release"

    if [ -n "$ROLLBACK_COMMAND" ]; then
        log "Exécution de la commande de rollback : $ROLLBACK_COMMAND"
        eval "$ROLLBACK_COMMAND"
    fi
}

# Fonction pour cloner le dépôt Git
clone_repo() {
    local release_dir=$1
    if ! command -v git &> /dev/null; then
        echo "Git n'est pas installé ou n'est pas accessible."
        exit 1
    fi

    log "Clonage du dépôt $GIT_REPO (branche: $GIT_BRANCH, dossier: $GIT_FOLDER)"
    git clone -b "$GIT_BRANCH" "$GIT_REPO" "$release_dir/$GIT_FOLDER"
}

# Fonction pour exécuter le build
run_build() {
    local release_dir=$1
    if [ -n "$BUILD_COMMAND" ]; then
        log "Exécution de la commande de build : $BUILD_COMMAND"
        (cd "$release_dir" && eval "$BUILD_COMMAND")
    elif [ -f "$release_dir/Makefile" ]; then
        if [ "$NO_INTERACTION" = true ]; then
            log "Makefile détecté, exécution de 'make'"
            (cd "$release_dir" && make)
        else
            read -p "Un Makefile a été détecté. Voulez-vous exécuter 'make'? (Y/n) " response
            if [[ $response =~ ^[Yy]$ ]] || [ -z "$response" ]; then
                (cd "$release_dir" && make)
            fi
        fi
    fi
}

# Fonction pour afficher l'aide
show_help() {
    echo "Usage: $0 [options] {deploy|rollback}"
    echo
    echo "Options:"
    echo "  -h, --help                Affiche cette aide"
    echo "  -v, --verbose             Mode verbeux"
    echo "  -q, --quiet               Mode silencieux"
    echo "  -n, --no-interaction      Désactive les prompts interactifs"
    echo "  -V, --version             Affiche la version du script"
    echo "  -k, --keep-releases N     Nombre de releases à conserver (défaut: 5)"
    echo "  -r, --repo URL            URL du dépôt Git"
    echo "  -b, --branch NOM          Nom de la branche ou du tag Git"
    echo "  -f, --folder NOM          Dossier spécifique du dépôt à déployer"
    echo "  --build-command CMD       Commande de build à exécuter"
    echo "  --rollback-command CMD    Commande à exécuter lors d'un rollback"
}

# Gestion des options
while [[ $# -gt 0 ]]; do
    case $1 in
        -h|--help)
            show_help
            exit 0
            ;;
        -v|--verbose)
            VERBOSE=true
            shift
            ;;
        -q|--quiet)
            QUIET=true
            shift
            ;;
        -n|--no-interaction)
            NO_INTERACTION=true
            shift
            ;;
        -V|--version)
            echo "Version: $VERSION"
            exit 0
            ;;
        -k|--keep-releases)
            KEEP_RELEASES=$2
            shift 2
            ;;
        -r|--repo)
            GIT_REPO=$2
            shift 2
            ;;
        -b|--branch)
            GIT_BRANCH=$2
            shift 2
            ;;
        -f|--folder)
            GIT_FOLDER=$2
            shift 2
            ;;
        --build-command)
            BUILD_COMMAND=$2
            shift 2
            ;;
        --rollback-command)
            ROLLBACK_COMMAND=$2
            shift 2
            ;;
        deploy|rollback)
            COMMAND=$1
            shift
            ;;
        *)
            echo "Option non reconnue: $1"
            exit 1
            ;;
    esac
done

# Vérification de la commande
if [ -z "$COMMAND" ]; then
    echo "Erreur: Aucune commande spécifiée (deploy ou rollback)"
    show_help
    exit 1
fi

# Exécution de la commande
case "$COMMAND" in
    deploy)
        create_structure
        create_release
        clone_repo "project/releases/$(get_date)"
        run_build "project/releases/$(get_date)"
        cleanup_releases "$KEEP_RELEASES"
        ;;
    rollback)
        rollback
        ;;
    *)
        echo "Commande non reconnue. Utilisez 'deploy' ou 'rollback'."
        exit 1
        ;;
esac