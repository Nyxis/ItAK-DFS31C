#!/bin/bash

# Activer le mode strict
set -euo pipefail

# Version du script
VERSION="1.0.0"

# ====== CONFIGURATION ======
# Charger les variables d'environnement si le fichier .env existe
[ -f .env ] && source .env

# Définir les variables globales avec des valeurs par défaut
PROJET=$(realpath "${PROJECT_ROOT:-"$PWD"}")
NOMBRE_VERSIONS=${KEEP_VERSIONS:-5}
DATE=$(date +%Y%m%d%H%M%S)
REPO_URL=${GIT_REPO:-""}
REPO_BRANCH=${GIT_BRANCH:-"main"}
REPO_FOLDER=${GIT_FOLDER:-""}
BUILD_COMMAND=""
ROLLBACK_COMMAND=""
MAKEFILE_TARGET=""
MAKEFILE_PATH=""
VERBOSE=false
QUIET=false
NO_INTERACTION=false

# ====== FONCTIONS UTILITAIRES ======
# Fonction pour afficher des messages horodatés
log() {
    if [ "$QUIET" = false ]; then
        echo "[$(date +'%Y-%m-%d %H:%M:%S')] $1"
    fi
}

# Fonction pour afficher des messages de debug
debug() {
    if [ "$VERBOSE" = true ] && [ "$QUIET" = false ]; then
        echo "[DEBUG] $1"
    fi
}

# Fonction pour gérer les erreurs de manière uniforme
erreur() {
    log "ERREUR: $1" >&2
    exit 1
}

# ====== FONCTIONS PRINCIPALES ======
# Fonction pour vérifier si Git est installé
verifier_git() {
    if ! command -v git &> /dev/null; then
        erreur "Git n'est pas installé ou n'est pas accessible."
    fi
}

# Fonction pour cloner un dépôt Git
cloner_repo() {
    local RELEASE_DIR="$1"

    verifier_git

    if [ -n "$REPO_URL" ]; then
        debug "Clonage du dépôt $REPO_URL dans $RELEASE_DIR"
        if [ -n "$REPO_FOLDER" ]; then
            debug "Clonage sparse du dépôt $REPO_URL (dossier: $REPO_FOLDER, branche: $REPO_BRANCH)"
            git clone --depth 1 --filter=blob:none --sparse "$REPO_URL" "$RELEASE_DIR" || erreur "Échec du clonage du dépôt"
            (
                cd "$RELEASE_DIR" || erreur "Impossible d'accéder au répertoire $RELEASE_DIR"
                git sparse-checkout set "$REPO_FOLDER"
                git checkout "$REPO_BRANCH" || erreur "Impossible de basculer sur la branche $REPO_BRANCH"
                mv "$REPO_FOLDER"/* . || erreur "Impossible de déplacer les fichiers du dossier $REPO_FOLDER"
                rm -rf "$REPO_FOLDER" .git
            )
        else
            debug "Clonage complet du dépôt $REPO_URL (branche: $REPO_BRANCH)"
            git clone --depth 1 --branch "$REPO_BRANCH" "$REPO_URL" "$RELEASE_DIR" || erreur "Échec du clonage du dépôt"
            rm -rf "$RELEASE_DIR/.git"
        fi
        log "Dépôt cloné avec succès dans $RELEASE_DIR"
    else
        log "Aucun dépôt Git spécifié, utilisation des fichiers partagés uniquement"
    fi
}

# Fonction pour copier les fichiers partagés
copier_fichiers_partages() {
    local RELEASE_DIR="$1"
    if [ -d "$PROJET/shared" ]; then
        debug "Copie des fichiers partagés"
        find "$PROJET/shared" -type f | while read -r file; do
            local rel_path="${file#$PROJET/shared/}"
            local target_dir="$RELEASE_DIR/$(dirname "$rel_path")"
            mkdir -p "$target_dir"
            ln -s "$file" "$target_dir/$(basename "$file")" || erreur "Impossible de créer le lien symbolique pour $file"
        done
    else
        debug "Aucun dossier 'shared' trouvé dans $PROJET"
    fi
}

# Fonction pour nettoyer les anciennes versions
nettoyer_anciennes_versions() {
    local versions_count
    versions_count=$(ls -1 "$PROJET/release" 2>/dev/null | wc -l)
    if [ "$versions_count" -gt "$NOMBRE_VERSIONS" ]; then
        debug "Nettoyage des anciennes versions"
        (cd "$PROJET/release" && ls -t | tail -n +$((NOMBRE_VERSIONS + 1)) | xargs -r rm -rf)
        log "Conservation des $NOMBRE_VERSIONS versions les plus récentes."
    else
        debug "Aucun nettoyage nécessaire. Il y a actuellement $versions_count version(s)."
    fi
}

executer_build() {
    local RELEASE_DIR="$1"
    cd "$RELEASE_DIR" || erreur "Impossible d'accéder au répertoire de build: $RELEASE_DIR"

    # Si une commande de build personnalisée est fournie
    if [ -n "$BUILD_COMMAND" ]; then
        debug "Exécution de la commande de build personnalisée: $BUILD_COMMAND"
        echo "Commande: $BUILD_COMMAND"
        
        # Exécuter la commande de build et afficher la sortie sur le terminal
        eval "$BUILD_COMMAND" 2>&1 || erreur "Échec du build"
        
        echo "Fin de la sortie de la commande de build"
    fi

    # Cette partie propose maintenant d'exécuter le Makefile, qu'une commande personnalisée ait été fournie ou non
    local makefile_to_use=""
    if [ -n "$MAKEFILE_PATH" ]; then
        makefile_to_use="$MAKEFILE_PATH"
        debug "Utilisation du Makefile spécifié: $makefile_to_use"
    else
        debug "Recherche récursive de Makefile dans $RELEASE_DIR"
        makefile_to_use=$(find "$RELEASE_DIR" -name "Makefile" -o -name "makefile" | head -n 1)
    fi

    if [ -n "$makefile_to_use" ]; then
        debug "Makefile trouvé: $makefile_to_use"
        if [ "$NO_INTERACTION" = false ]; then
            read -p "Voulez-vous exécuter 'make -f $makefile_to_use' ? (Y/n) " -n 1 -r
            echo
        else
            REPLY="Y"
        fi
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            if [ -n "$MAKEFILE_TARGET" ]; then
                debug "Exécution de 'make -f $makefile_to_use $MAKEFILE_TARGET'"
                make -f "$makefile_to_use" "$MAKEFILE_TARGET" || erreur "Échec de l'exécution de 'make $MAKEFILE_TARGET'"
            else
                debug "Exécution de 'make -f $makefile_to_use'"
                make -f "$makefile_to_use" || erreur "Échec de l'exécution de 'make'"
            fi
        else
            debug "L'exécution du Makefile est ignorée."
        fi
    else
        debug "Aucun Makefile détecté dans $RELEASE_DIR."
    fi

    debug "Fin de l'exécution de la fonction executer_build"
}

# Fonction principale de déploiement
deploy() {
    local RELEASE_DIR="$PROJET/release/$DATE"
    mkdir -p "$RELEASE_DIR" || erreur "Impossible de créer le répertoire $RELEASE_DIR"
    log "Création du répertoire de release: $RELEASE_DIR"

    cloner_repo "$RELEASE_DIR"
    copier_fichiers_partages "$RELEASE_DIR"

    if [ -z "$(ls -A "$RELEASE_DIR")" ]; then
        erreur "Aucun fichier à déployer. Vérifiez votre configuration de dépôt Git ou le dossier 'shared'."
    fi

    executer_build "$RELEASE_DIR"

    mkdir -p "$(dirname "$PROJET/current")" || erreur "Impossible de créer le répertoire parent de 'current'"
    ln -sfn "$RELEASE_DIR" "$PROJET/current" || erreur "Impossible de créer le lien symbolique vers la nouvelle version"
    log "Nombre de versions à conserver: $NOMBRE_VERSIONS"
    log "Nouvelle version déployée: $DATE"

    nettoyer_anciennes_versions
}

# Fonction de rollback
rollback() {
    local steps=${1:-1}
    local current_version=$(readlink "$PROJET/current")
    local versions=($(ls -t "$PROJET/release"))
    local target_index=0

    for i in "${!versions[@]}"; do
        if [[ "$PROJET/release/${versions[i]}" == "$current_version" ]]; then
            target_index=$((i + steps))
            break
        fi
    done

    if [[ $target_index -ge ${#versions[@]} ]]; then
        erreur "Impossible de revenir $steps version(s) en arrière. Il n'y a que ${#versions[@]} versions disponibles."
    fi

    local target_version="${versions[$target_index]}"
    if ln -sfn "$PROJET/release/$target_version" "$PROJET/current"; then
        log "Retour à la version: $target_version"
        if [ -n "$ROLLBACK_COMMAND" ]; then
            debug "Exécution de la commande de rollback: $ROLLBACK_COMMAND"
            (cd "$PROJET/current" && eval "$ROLLBACK_COMMAND") || erreur "Échec de l'exécution de la commande de rollback"
        fi
    else
        erreur "Impossible de créer le lien symbolique pour le rollback"
    fi
}

# ====== TRAITEMENT DES ARGUMENTS ======
# Fonction pour analyser les arguments de la ligne de commande
parse_arguments() {
    local command=""
    local rollback_steps=1
    while getopts ":n:r:b:f:s:c:k:m:p:hvqnV" opt; do
        case $opt in
            n) [[ $OPTARG =~ ^[0-9]+$ ]] && [ "$OPTARG" -gt 0 ] && NOMBRE_VERSIONS=$OPTARG ;;
            r) REPO_URL=$OPTARG; debug "URL du dépôt définie: $REPO_URL" ;;
            b) REPO_BRANCH=$OPTARG; debug "Branche du dépôt définie: $REPO_BRANCH" ;;
            f) REPO_FOLDER=$OPTARG; debug "Dossier du dépôt défini: $REPO_FOLDER" ;;
            s) rollback_steps=$OPTARG ;;
            c) BUILD_COMMAND=$OPTARG; debug "Commande de build définie: $BUILD_COMMAND" ;;
            k) ROLLBACK_COMMAND=$OPTARG ;;
            m) MAKEFILE_TARGET=$OPTARG ;;
            p) MAKEFILE_PATH=$OPTARG ;;
            h) afficher_aide; exit 0 ;;
            v) VERBOSE=true ;;
            q) QUIET=true ;;
            n) NO_INTERACTION=true ;;
            V) echo "Version: $VERSION"; exit 0 ;;
            *) erreur "Option invalide: -$OPTARG" ;;
        esac
    done
    shift $((OPTIND - 1))

    # Vérifier s'il reste des arguments non-options
    if [ $# -gt 0 ]; then
        command="$1"
    else
        echo "Aucune commande spécifiée. Pour voir l'aide, utilisez : $0 -h ou $0 help"
        exit 1
    fi

    case "$command" in
        deploy) deploy ;;
        rollback) rollback "$rollback_steps" ;;
        help) afficher_aide ;;
        *) erreur "Commande invalide: $command. Utilisez '$0 help' pour voir l'aide." ;;
    esac
}

# Fonction d'aide
afficher_aide() {
    echo "Usage: $0 [options] {deploy|rollback}"
    echo
    echo "Options:"
    echo "  -n nombre     Nombre de versions à conserver (défaut: 5)"
    echo "  -r url        URL du dépôt Git"
    echo "  -b branche    Branche Git à utiliser (défaut: main)"
    echo "  -f dossier    Dossier spécifique du dépôt à cloner"
    echo "  -s steps      Nombre d'étapes pour le rollback (défaut: 1)"
    echo "  -c commande   Commande de build personnalisée"
    echo "  -k commande   Commande de rollback personnalisée"
    echo "  -m cible      Cible Makefile à exécuter"
    echo "  -p chemin     Chemin vers le Makefile"
    echo "  -h            Affiche cette aide"
    echo "  -v            Mode verbose"
    echo "  -q            Mode silencieux"
    echo "  -n            Mode sans interaction"
    echo "  -V            Affiche la version du script"
    echo
    echo "Commandes:"
    echo "  deploy        Déployer une nouvelle version"
    echo "  rollback      Revenir à une version précédente"
}

# ====== MAIN ======
# Fonction principale qui démarre l'exécution du script
main() {
    if [ $# -eq 0 ]; then
        echo "Aucun argument fourni. Pour voir l'aide, utilisez : $0 -h ou $0 help"
        exit 1
    fi
    parse_arguments "$@"
}

main "$@"
