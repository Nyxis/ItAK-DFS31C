#!/bin/bash

set -e  # Arrête le script si une commande échoue

# Chargement des variables d'environnement
if [ -f .env ]; then
    source .env
fi

# Variables globales
PROJECT_ROOT=${PROJECT_ROOT:-$(realpath "./project")}
RELEASES_DIR="${PROJECT_ROOT}/releases"
SHARED_DIR="${PROJECT_ROOT}/shared"
CURRENT_LINK="${PROJECT_ROOT}/current"
DEFAULT_KEEP_RELEASES=${DEFAULT_KEEP_RELEASES:-5}
GIT_REPO=${GIT_REPO:-""}
GIT_BRANCH=${GIT_BRANCH:-""}
GIT_FOLDER=${GIT_FOLDER:-""}

# Fonction pour vérifier les prérequis
check_prerequisites() {
    command -v realpath >/dev/null 2>&1 || { echo "realpath est requis mais n'est pas installé. Abandon." >&2; exit 1; }
    command -v git >/dev/null 2>&1 || { echo "git est requis mais n'est pas installé. Abandon." >&2; exit 1; }
}

# Fonction pour obtenir la date au format YYYYMMDDHHmmss
get_current_date() {
    date +"%Y%m%d%H%M%S"
}

# Fonction pour créer la structure de base du projet
create_project_structure() {
    mkdir -p "${RELEASES_DIR}" "${SHARED_DIR}" || { echo "Erreur lors de la création de la structure du projet" >&2; return 1; }
    echo "Structure du projet créée"
    return 0
}

# Fonction pour créer une nouvelle release
create_new_release() {
    local release_date=$(get_current_date)
    local release_dir="${RELEASES_DIR}/${release_date}"
    local temp_dir=$(mktemp -d)
    git clone --branch "$GIT_BRANCH" "$GIT_REPO" "$temp_dir" || { echo "Erreur lors du clonage du dépôt Git" >&2; return 1; }
    mkdir -p "$release_dir"
    mv "$temp_dir/$GIT_FOLDER"/* "$release_dir/" || { echo "Erreur lors du déplacement des fichiers" >&2; return 1; }
    rm -rf "$temp_dir"
    echo "Nouvelle release créée : ${release_dir}"
    return 0
}

# Fonction pour copier les fichiers partagés
copy_shared_files() {
    local release_dir="${RELEASES_DIR}/$(ls -t ${RELEASES_DIR} | head -n1)"
    local error_count=0
    find "${SHARED_DIR}" -type f | while read file; do
        local relative_path="${file#${SHARED_DIR}/}"
        local target_dir="${release_dir}/$(dirname "${relative_path}")"
        mkdir -p "${target_dir}" || { echo "Erreur lors de la création du répertoire cible pour ${file}" >&2; ((error_count++)); continue; }
        ln -s "${file}" "${target_dir}/$(basename "${file}")" || { echo "Erreur lors de la création du lien symbolique pour ${file}" >&2; ((error_count++)); }
    done
    if [ $error_count -gt 0 ]; then
        echo "Des erreurs sont survenues lors de la copie des fichiers partagés" >&2
        return 1
    fi
    echo "Fichiers partagés liés symboliquement"
    return 0
}

# Fonction pour mettre à jour le lien current
update_current_link() {
    local latest_release=$(ls -t ${RELEASES_DIR} | head -n1)
    ln -sfn "${RELEASES_DIR}/${latest_release}" "${CURRENT_LINK}" || { echo "Erreur lors de la mise à jour du lien 'current'" >&2; return 1; }
    echo "Lien 'current' mis à jour vers ${latest_release}"
    return 0
}

# Fonction pour nettoyer les anciennes releases
cleanup_old_releases() {
    local keep_releases=${1:-$DEFAULT_KEEP_RELEASES}
    if ! [[ "$keep_releases" =~ ^[0-9]+$ ]] || [ "$keep_releases" -lt 1 ]; then
        echo "Nombre invalide de releases à conserver" >&2
        return 1
    fi
    local releases_to_delete=$(ls -t ${RELEASES_DIR} | tail -n +$((keep_releases + 1)))
    if [ -n "${releases_to_delete}" ]; then
        echo "${releases_to_delete}" | xargs -I {} rm -rf "${RELEASES_DIR}/{}" || { echo "Erreur lors du nettoyage des anciennes releases" >&2; return 1; }
        echo "Anciennes releases nettoyées"
    fi
    return 0
}

# Fonction pour effectuer un rollback
perform_rollback() {
    local current_release=$(readlink "${CURRENT_LINK}")
    local previous_release=$(ls -t ${RELEASES_DIR} | grep -v "$(basename "${current_release}")" | head -n1)
    if [ -n "${previous_release}" ]; then
        ln -sfn "${RELEASES_DIR}/${previous_release}" "${CURRENT_LINK}" || { echo "Erreur lors du rollback" >&2; return 1; }
        echo "Rollback effectué vers ${previous_release}"
    else
        echo "Impossible d'effectuer le rollback : aucune release précédente trouvée" >&2
        return 1
    fi
}

# Fonction pour le déploiement
deploy() {
    local keep_releases=$1
    create_project_structure || return 1
    create_new_release || return 1
    copy_shared_files || return 1
    update_current_link || return 1
    cleanup_old_releases "$keep_releases" || return 1
    echo "Déploiement terminé avec succès"
}

# Fonction principale
main() {
    local keep_releases=$DEFAULT_KEEP_RELEASES
    local command=""

    # Vérification des prérequis
    check_prerequisites

    # Traitement des options
    while getopts ":k:r:b:f:" opt; do
        case ${opt} in
            k )
                keep_releases=$OPTARG
                ;;
            r )
                GIT_REPO=$OPTARG
                ;;
            b )
                GIT_BRANCH=$OPTARG
                ;;
            f )
                GIT_FOLDER=$OPTARG
                ;;
            \? )
                echo "Option invalide : -$OPTARG" >&2
                exit 1
                ;;
            : )
                echo "L'option -$OPTARG requiert un argument." >&2
                exit 1
                ;;
        esac
    done
    shift $((OPTIND -1))

    # Récupération de la commande
    command=$1

    case $command in
        deploy)
            deploy $keep_releases
            ;;
        rollback)
            perform_rollback
            ;;
        *)
            echo "Usage: $0 [-k nombre_de_releases] [-r repo_git] [-b branche_git] [-f dossier_git] {deploy|rollback}" >&2
            exit 1
            ;;
    esac
}

# Gestion des signaux
trap 'echo "Interruption du script"; exit 1' INT TERM

# Exécution du script
main "$@"