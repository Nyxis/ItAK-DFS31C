#!/bin/bash

# Variables globales
PROJECT_ROOT="./project"
RELEASES_DIR="${PROJECT_ROOT}/releases"
SHARED_DIR="${PROJECT_ROOT}/shared"
CURRENT_LINK="${PROJECT_ROOT}/current"
DEFAULT_KEEP_RELEASES=5

# Fonction pour obtenir la date au format YYYYMMDDHHmmss
get_current_date() {
    date +"%Y%m%d%H%M%S"
}

# Fonction pour créer la structure de base du projet
create_project_structure() {
    mkdir -p "${RELEASES_DIR}" "${SHARED_DIR}"
    echo "Structure du projet créée"
}

# Fonction pour nettoyer les anciennes releases
cleanup_old_releases() {
    local keep_releases=${1:-$DEFAULT_KEEP_RELEASES}
    local releases_to_delete=$(ls -t ${RELEASES_DIR} | tail -n +$((keep_releases + 1)))
    if [ -n "${releases_to_delete}" ]; then
        echo "${releases_to_delete}" | xargs -I {} rm -rf "${RELEASES_DIR}/{}"
        echo "Anciennes releases nettoyées"
    fi
}

# Fonction pour copier les fichiers partagés
copy_shared_files() {
    local release_dir="${RELEASES_DIR}/$(ls -t ${RELEASES_DIR} | head -n1)"
    find "${SHARED_DIR}" -type f | while read file; do
        local relative_path="${file#${SHARED_DIR}/}"
        local target_dir="${release_dir}/$(dirname "${relative_path}")"
        mkdir -p "${target_dir}"
        ln -s "${file}" "${target_dir}/$(basename "${file}")"
    done
    echo "Fichiers partagés liés symboliquement"
}

# Fonction pour mettre à jour le lien current
update_current_link() {
    local latest_release=$(ls -t ${RELEASES_DIR} | head -n1)
    ln -sfn "${RELEASES_DIR}/${latest_release}" "${CURRENT_LINK}"
    echo "Lien 'current' mis à jour vers ${latest_release}"
}

# Fonction principale
main() {
    local keep_releases=$DEFAULT_KEEP_RELEASES

    # Traitement des options
    while getopts ":k:" opt; do
        case ${opt} in
            k )
                keep_releases=$OPTARG
                ;;
            \? )
                echo "Option invalide : -$OPTARG" 1>&2
                exit 1
                ;;
            : )
                echo "L'option -$OPTARG requiert un argument." 1>&2
                exit 1
                ;;
        esac
    done

    create_project_structure
    current_date=$(get_current_date)
    echo "Date courante : ${current_date}"
    mkdir -p "${RELEASES_DIR}/${current_date}"
    echo "Nouveau dossier de release créé : ${RELEASES_DIR}/${current_date}"
    copy_shared_files
    update_current_link
    cleanup_old_releases $keep_releases
}

# Exécution du script
main "$@"