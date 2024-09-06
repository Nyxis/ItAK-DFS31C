#!/bin/bash

VERSION="1.0.0"
verbose=false
quiet=false
no_interaction=false

# Fonction de logging
log() {
    if [ "$quiet" = false ]; then
        echo "$@"
    fi
}

usage() {
    echo "Usage: $0 [OPTIONS] {deploy|rollback}"
    echo "Options:"
    echo "  -k <number>   Nombre de dernières releases à conserver (par défaut: 5)"
    echo "  -r <repo>     URL du dépôt Git à cloner"
    echo "  -v <version>  Version (tag ou branche) à déployer"
    echo "  -d <directory> Dossier spécifique du dépôt à déployer"
    echo "  -B <command>  Commande de build à exécuter"
    echo "  -R <command>  Commande de rollback à exécuter"
    echo "  -h, --help    Afficher ce message d'aide"
    echo "  -v, --verbose Afficher les messages de débogage"
    echo "  -q, --quiet   Désactiver l'affichage de tous les messages à l'exception des prompts"
    echo "  -n, --no-interaction  Désactiver les prompts (utiliser les réponses par défaut)"
    echo "  -V, --version Afficher la version du script"
    echo
    echo "Actions:"
    echo "  deploy        Déployer une nouvelle release"
    echo "  rollback      Retourner à la version précédente"
    exit 1
}

# Chargement du fichier .env
load_env() {
    if [ -f .env ]; then
        source .env
        log "Fichier .env chargé avec succès depuis le répertoire courant."
    else
        log "Attention : le fichier .env n'a pas été trouvé dans le répertoire courant."
        if [ "$no_interaction" = false ]; then
            read -p "Souhaitez-vous spécifier un chemin pour le fichier .env ? (y/n) " response
            if [[ "$response" == "y" || "$response" == "Y" ]]; then
                read -p "Veuillez entrer le chemin complet du fichier .env : " env_path
                if [ -f "$env_path" ]; then
                    source "$env_path"
                    log "Fichier .env chargé avec succès depuis : $env_path"
                else
                    echo "Erreur : le fichier .env n'a pas été trouvé à l'emplacement spécifié."
                    exit 1
                fi
            else
                log "Aucun fichier .env n'a été chargé. Certaines variables d'environnement peuvent manquer."
            fi
        fi
    fi
}

# Vérification de la disponibilité de Git
check_git() {
    if ! command -v git &> /dev/null; then
        echo "Git n'est pas installé ou n'est pas accessible. Veuillez l'installer et réessayer."
        exit 1
    fi
}

# Validation du dépôt Git
validate_git_repo() {
    if ! git ls-remote "$git_repo" &> /dev/null; then
        echo "Le dépôt Git spécifié est inaccessible : $git_repo"
        echo "Erreur détaillée :"
        git ls-remote "$git_repo"
        exit 1
    fi
}

# Déploiement d'une nouvelle release
deploy() {
    check_git
    validate_git_repo
    current_date=$(date +"%Y%m%d%H%M%S")
    release_dir="$project_dir/releases/$current_date"
    
    log "Création d'une nouvelle release: $current_date"
    
    git clone --depth 1 --branch "$git_version" "$git_repo" "$release_dir"
    
    if [ -n "$git_directory" ]; then
        if [ -d "$release_dir/$git_directory" ]; then
            log "Sous-dossier trouvé: $git_directory"
            mv "$release_dir/$git_directory"/* "$release_dir/"
            find "$release_dir" -maxdepth 1 -type d ! -name "$(basename "$release_dir")" -exec rm -rf {} +
        else
            echo "Erreur : le sous-dossier spécifié '$git_directory' n'existe pas dans le dépôt."
            ls -R "$release_dir"
            exit 1
        fi
    fi

    # Exécution de la commande de build
    if [ -n "$build_command" ]; then
        log "Exécution de la commande de build: $build_command"
        if ! eval "$build_command"; then
            echo "Erreur lors du build. Arrêt du déploiement."
            exit 1
        fi
    elif [ -f "$release_dir/Makefile" ] && [ "$no_interaction" = false ]; then
        read -p "Un Makefile a été détecté. Voulez-vous exécuter 'make'? (Y/n) " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]] || [[ -z $REPLY ]]; then
            if ! make -C "$release_dir"; then
                echo "Erreur lors de l'exécution de make. Arrêt du déploiement."
                exit 1
            fi
        fi
    fi

    find "$project_dir/shared" -type f | while read -r file; do
        relative_path=${file#$project_dir/shared/}
        target_dir="$release_dir/$(dirname "$relative_path")"
        mkdir -p "$target_dir"
        ln -s "$file" "$target_dir/$(basename "$file")"
    done

    ln -sfn "$release_dir" "$project_dir/current"
    log "Lien 'current' mis à jour: $project_dir/current -> $release_dir"

    cleanup_old_releases

    log "Déploiement terminé. La nouvelle release est disponible dans $release_dir"
}

# Rollback à la version précédente
rollback() {
    cd "$project_dir/releases" || exit
    current_release=$(readlink -f "$project_dir/current")
    previous_release=$(ls -t | sed -n '2p')

    if [ -z "$previous_release" ]; then
        echo "Aucune release précédente disponible pour le rollback."
        exit 1
    fi

    ln -sfn "$project_dir/releases/$previous_release" "$project_dir/current"
    log "Rollback effectué. Current pointe maintenant vers: $previous_release"

    if [ -n "$rollback_command" ]; then
        log "Exécution de la commande de rollback: $rollback_command"
        if ! eval "$rollback_command"; then
            echo "Erreur lors de l'exécution de la commande de rollback."
            exit 1
        fi
    fi
}

# Nettoyage des anciennes releases
cleanup_old_releases() {
    cd "$project_dir/releases" || exit
    releases_to_delete=$(ls -t | tail -n +$((keep_releases + 1)))
    if [ -n "$releases_to_delete" ]; then
        log "Suppression des anciennes releases:"
        log "$releases_to_delete"
        rm -rf $releases_to_delete
    fi
}

# Valeurs par défaut
keep_releases=5
git_repo=""
git_version="main"
git_directory=""
build_command=""
rollback_command=""
verbose=false
no_interaction=false
project_dir="$(pwd)/project"

# Chargement du fichier .env
load_env

# Traitement des options
while [[ $# -gt 0 ]]; do
    case "$1" in
        -k) keep_releases="$2"; shift 2 ;;
        -r) git_repo="$2"; shift 2 ;;
        -v) git_version="$2"; shift 2 ;;
        -d) git_directory="$2"; shift 2 ;;
        -B) build_command="$2"; shift 2 ;;
        -R) rollback_command="$2"; shift 2 ;;
        deploy|rollback) action="$1"; shift ;;
        -h|--help) usage; exit 0 ;;
        --verbose) verbose=true; shift ;;
        -q|--quiet) quiet=true; shift ;;
        --no-interaction) no_interaction=true; shift ;;
        -V|--version) echo "deployAuto version $VERSION"; exit 0 ;;
        *) echo "Option invalide: $1" >&2; usage ;;
    esac
done

# Vérification des variables obligatoires
if [ -z "$git_repo" ]; then
    echo "Erreur : L'URL du dépôt Git (-r) est obligatoire."
    usage
fi

if [ -z "$action" ]; then
    echo "Erreur : Vous devez spécifier une action (deploy ou rollback)."
    usage
fi

# Affichage des variables en mode verbose
if $verbose; then
    log "git_repo: $git_repo"
    log "git_version: $git_version"
    log "git_directory: $git_directory"
    log "action: $action"
    log "keep_releases: $keep_releases"
    log "build_command: $build_command"
    log "rollback_command: $rollback_command"
    log "no_interaction: $no_interaction"
fi

# Création des dossiers nécessaires
mkdir -p "$project_dir"/{releases,shared/lib}

# Exécution de l'action
case "$action" in
    deploy) deploy ;;
    rollback) rollback ;;
    *) echo "Action non reconnue: $action"; usage ;;
esac