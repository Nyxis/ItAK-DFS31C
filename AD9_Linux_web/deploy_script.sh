#!/bin/bash

# Fonction pour obtenir la date au format YYYYMMDDHHmmss
get_date() {
    date +%Y%m%d%H%M%S
}

# Fonction pour créer la structure de dossiers
create_structure() {
    mkdir -p project/releases project/shared
}

# Fonction pour créer une nouvelle release
create_release() {
    local date=$(get_date)
    mkdir -p "project/releases/$date"
    echo "Nouvelle release créée : $date"
    
    # Copier ou lier les fichiers partagés
    find project/shared -type f -exec ln -s "$(pwd)/{}" "project/releases/$date/{}" \;
    
    # Mettre à jour le lien 'current'
    ln -sfn "$(pwd)/project/releases/$date" project/current
}

# Fonction pour nettoyer les anciennes releases
cleanup_releases() {
    local keep=${1:-5}
    cd project/releases
    ls -t | tail -n +$((keep + 1)) | xargs rm -rf
    cd ../..
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
    echo "Rollback effectué vers la release : $previous_release"
}

# Gestion des options
while getopts ":k:" opt; do
    case $opt in
        k)
            KEEP_RELEASES=$OPTARG
            ;;
        \?)
            echo "Option invalide: -$OPTARG" >&2
            exit 1
            ;;
        :)
            echo "L'option -$OPTARG requiert un argument." >&2
            exit 1
            ;;
    esac
done

shift $((OPTIND -1))

# Vérification de la commande
if [ $# -eq 0 ]; then
    echo "Usage: $0 [-k nombre_de_releases_à_garder] {deploy|rollback}"
    exit 1
fi

# Exécution de la commande
case "$1" in
    deploy)
        create_structure
        create_release
        cleanup_releases ${KEEP_RELEASES:-5}
        ;;
    rollback)
        rollback
        ;;
    *)
        echo "Commande non reconnue. Utilisez 'deploy' ou 'rollback'."
        exit 1
        ;;
esac