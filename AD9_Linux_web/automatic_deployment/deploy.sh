#!/bin/bash

# Variables globales
PROJECT_ROOT="./project"
RELEASES_DIR="${PROJECT_ROOT}/releases"
SHARED_DIR="${PROJECT_ROOT}/shared"

# Fonction pour obtenir la date au format YYYYMMDDHHmmss
get_current_date() {
    date +"%Y%m%d%H%M%S"
}

# Fonction pour créer la structure de base du projet
create_project_structure() {
    mkdir -p "${RELEASES_DIR}" "${SHARED_DIR}"
    echo "Structure du projet créée"
}

# Fonction principale
main() {
    create_project_structure
    current_date=$(get_current_date)
    echo "Date courante : ${current_date}"
    mkdir -p "${RELEASES_DIR}/${current_date}"
    echo "Nouveau dossier de release créé : ${RELEASES_DIR}/${current_date}"
}

# Exécution du script
main