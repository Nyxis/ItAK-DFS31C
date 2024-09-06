#!/bin/bash

# Chargement des paramètres
if [ -f .env ]; then
    source .env
fi

# Paramètres par défaut
KEEP_RELEASES=5
REPO_URL=${DEFAULT_REPO_URL:-}
REPO_BRANCH=${DEFAULT_REPO_BRANCH:-main}
REPO_DIR=${DEFAULT_REPO_DIR:-}
BUILD_COMMAND=""
ROLLBACK_COMMAND=""
VERBOSE=false
QUIET=false
NO_INTERACTION=false
VERSION="1.0.0"

# Fonction pour afficher l'aide
show_help() {
    echo "Utilisation: $0 [OPTIONS] COMMANDE"
    echo "Commandes:"
    echo "  deploy    Déployer une nouvelle version"
    echo "  rollback  Revenir à la version précédente"
    echo "Options:"
    echo "  -k NOMBRE     Nombre de releases à conserver (par défaut: 5)"
    echo "  -u URL        URL du dépôt Git"
    echo "  -b BRANCHE    Branche à cloner (par défaut: main)"
    echo "  -d DOSSIER    Sous-dossier du dépôt à cloner"
    echo "  --build COMMANDE   Commande de build à exécuter après le clonage"
    echo "  --rollback COMMANDE Commande de rollback à exécuter lors du retour arrière"
    echo "  -h, --help    Afficher cette aide"
    echo "  -v, --verbose Sortie verbeuse"
    echo "  -q, --quiet   Mode silencieux"
    echo "  -n, --no-interaction  Mode non interactif"
    echo "  -V, --version Afficher la version du script"
    echo "  --install-man Installer la page de manuel"
    echo "  --show-man    Afficher la page de manuel sans l'installer"
}

# Fonction pour afficher des messages
echo_message() {
    if [ "$QUIET" = false ]; then
        echo "$1"
    fi
}

# Fonction pour afficher des informations de débogage
echo_debug() {
    if [ "$VERBOSE" = true ]; then
        echo "DEBUG: $1"
    fi
}

# Fonction pour obtenir la date courante
get_current_date() {
    date +"%Y%m%d%H%M%S"
}

# Fonction pour vérifier la présence de Git
check_git() {
    if ! command -v git &> /dev/null; then
        echo_message "Erreur: Git n'est pas installé ou n'est pas accessible."
        exit 1
    fi
}

# Fonction pour cloner le dépôt
clone_repo() {
    local target_dir="$1"
    echo_debug "Clonage du dépôt: $REPO_URL"
    echo_debug "Branche: $REPO_BRANCH"
    echo_debug "Répertoire cible: $target_dir"

    git clone --depth 1 --branch "$REPO_BRANCH" "$REPO_URL" "$target_dir"
    if [ -n "$REPO_DIR" ]; then
        if [ -d "$target_dir/$REPO_DIR" ]; then
            mv "$target_dir/$REPO_DIR"/* "$target_dir/"
            rm -rf "$target_dir/$REPO_DIR"
        else
            echo_message "Erreur: Le sous-dossier spécifié '$REPO_DIR' n'existe pas dans le dépôt."
            exit 1
        fi
    fi
}

# Fonction pour créer des liens symboliques
create_symlinks() {
    local release_folder="$1"
    if [ ! -d "project/shared" ]; then
        echo_message "Création du dossier 'project/shared'..."
        mkdir -p project/shared
    fi
    for file in $(find project/shared -type f 2>/dev/null); do
        local relative_path=${file#project/shared/}
        local target_dir="$release_folder/$(dirname "$relative_path")"
        mkdir -p "$target_dir"
        ln -s "$(realpath "$file")" "$release_folder/$relative_path"
    done
    echo_message "Liens symboliques créés pour les fichiers partagés."
}

# Fonction pour mettre à jour le lien "current"
update_current_link() {
    local release_path="$1"
    ln -snf "$release_path" "project/current"
    echo_message "Lien 'current' mis à jour vers $(basename $release_path)"
}

# Fonction pour exécuter le build
do_build() {
    if [ -n "$BUILD_COMMAND" ]; then
        echo_message "Exécution de la commande de build: $BUILD_COMMAND"
        eval $BUILD_COMMAND
        if [ $? -ne 0 ]; then
            echo_message "Échec du build. Abandon du déploiement."
            exit 1
        fi
    elif [ -f Makefile ] && [ "$NO_INTERACTION" = false ]; then
        read -p "Makefile détecté. Exécuter 'make'? (O/n) " answer
        if [[ $answer != "n" && $answer != "N" ]]; then
            make
        fi
    fi
}

# Fonction pour le déploiement
deploy() {
    check_git
    local current_date=$(get_current_date)
    local release_dir="project/releases/$current_date"
    
    echo_message "Création de la structure de dossiers..."
    mkdir -p "$release_dir"
    mkdir -p project/shared

    echo_message "Clonage du dépôt..."
    clone_repo "$release_dir"
    
    echo_message "Création des liens symboliques..."
    create_symlinks "$release_dir"
    
    echo_message "Exécution du build..."
    do_build
    
    echo_message "Mise à jour du lien 'current'..."
    update_current_link "$release_dir"

    # Suppression des anciennes releases
    echo_message "Nettoyage des anciennes releases..."
    local all_releases=($(ls -1dt project/releases/* 2>/dev/null))
    local releases_to_delete=("${all_releases[@]:$KEEP_RELEASES}")
    for release in "${releases_to_delete[@]}"; do
        echo_message "Suppression de l'ancienne release: $release"
        rm -rf "$release"
    done
    echo_message "Nombre de releases conservées: $KEEP_RELEASES"
}

# Fonction pour le rollback
rollback() {
    if [ ! -L "project/current" ]; then
        echo_message "Erreur: Aucune release courante trouvée."
        exit 1
    fi

    local current_release=$(readlink project/current)
    local all_releases=($(ls -1dt project/releases/* 2>/dev/null))
    local previous_release=""

    for release in "${all_releases[@]}"; do
        if [ "$release" != "$current_release" ]; then
            previous_release="$release"
            break
        fi
    done

    if [ -z "$previous_release" ]; then
        echo_message "Erreur: Aucune release précédente trouvée pour le rollback."
        exit 1
    fi

    update_current_link "$previous_release"
    
    if [ -n "$ROLLBACK_COMMAND" ]; then
        echo_message "Exécution de la commande de rollback: $ROLLBACK_COMMAND"
        eval $ROLLBACK_COMMAND
    fi
}

# Fonction pour installer la page de manuel
install_man_page() {
    local script_dir=$(dirname "$(realpath "$0")")
    local man_file="$script_dir/deploy_man.1"
    
    if [ ! -f "$man_file" ]; then
        echo "Erreur: Fichier de page de manuel '$man_file' non trouvé."
        exit 1
    fi

    if [ -w /usr/local/man/man1 ]; then
        cp "$man_file" /usr/local/man/man1/
        mandb
        echo "Page de manuel installée avec succès."
    else
        echo "Erreur: Impossible d'installer la page de manuel. Exécutez le script avec sudo pour l'installation."
    fi
}

# Fonction pour afficher la page de manuel sans l'installer
show_man_page() {
    local script_dir=$(dirname "$(realpath "$0")")
    local man_file="$script_dir/deploy_man.1"
    
    if [ ! -f "$man_file" ]; then
        echo "Erreur: Fichier de page de manuel '$man_file' non trouvé."
        exit 1
    fi

    man "$man_file"
}

# Traitement des arguments de la ligne de commande
while [[ $# -gt 0 ]]; do
    case $1 in
        -k) KEEP_RELEASES="$2"; shift 2 ;;
        -u) REPO_URL="$2"; shift 2 ;;
        -b) REPO_BRANCH="$2"; shift 2 ;;
        -d) REPO_DIR="$2"; shift 2 ;;
        --build) BUILD_COMMAND="$2"; shift 2 ;;
        --rollback) ROLLBACK_COMMAND="$2"; shift 2 ;;
        -h|--help) show_help; exit 0 ;;
        -v|--verbose) VERBOSE=true; shift ;;
        -q|--quiet) QUIET=true; shift ;;
        -n|--no-interaction) NO_INTERACTION=true; shift ;;
        -V|--version) echo "Version du script: $VERSION"; exit 0 ;;
        --install-man) install_man_page; exit 0 ;;
        --show-man) show_man_page; exit 0 ;;
        deploy|rollback) COMMAND="$1"; shift ;;
        *) echo "Option inconnue: $1"; show_help; exit 1 ;;
    esac
done

# Exécution de la commande
case $COMMAND in
    deploy)
        deploy
        ;;
    rollback)
        rollback
        ;;
    *)
        echo "Commande non spécifiée. Utilisez 'deploy' ou 'rollback'."
        show_help
        exit 1
        ;;
esac