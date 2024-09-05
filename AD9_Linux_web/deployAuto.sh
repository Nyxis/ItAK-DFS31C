#!/bin/bash

# usage du script
usage() {
    echo "Usage: $0 [deploy|rollback] [-k <number>]"
    echo "  deploy        Déploie une nouvelle release"
    echo "  rollback      Retourne à la version précédente"
    echo "  -k <number>   Nombre de dernières releases à conserver (par défaut: 5)"
    exit 1
}

# defaut :
keep_releases=5

# nouvelle release
deploy() {
    current_date=$(date +"%Y%m%d%H%M%S")
    release_dir="$project_dir/releases/$current_date"
    mkdir -p "$release_dir"

    echo "Création d'une nouvelle release: $current_date"

    # Creer liens symboliques -> shared
    find "$project_dir/shared" -type f | while read -r file; do
        relative_path=${file#$project_dir/shared/}
        target_dir="$release_dir/$(dirname "$relative_path")"
        mkdir -p "$target_dir"
        ln -s "$file" "$target_dir/$(basename "$file")"
    done

    # maj lien 'current'
    ln -sfn "$release_dir" "$project_dir/current"
    echo "Lien 'current' mis à jour: $project_dir/current -> $release_dir"

    # Suppr old releases
    cd "$project_dir/releases" || exit
    releases_to_delete=$(ls -t | tail -n +$((keep_releases + 1)))
    if [ -n "$releases_to_delete" ]; then
        echo "Suppression des anciennes releases:"
        echo "$releases_to_delete"
        rm -rf $releases_to_delete
    fi

    echo "Déploiement terminé. La nouvelle release est disponible dans $release_dir"
}

# rollback
rollback() {
    cd "$project_dir/releases" || exit
    current_release=$(readlink -f "$project_dir/current")
    previous_release=$(ls -t | sed -n '2p')

    if [ -z "$previous_release" ]; then
        echo "Aucune release précédente disponible pour le rollback."
        exit 1
    fi

    ln -sfn "$project_dir/releases/$previous_release" "$project_dir/current"
    echo "Rollback effectué. Current pointe maintenant vers: $previous_release"
}

# options
while getopts ":k:" opt; do
    case ${opt} in
        k )
            keep_releases=$OPTARG
            ;;
        \? )
            echo "Option invalide: -$OPTARG" 1>&2
            usage
            ;;
        : )
            echo "L'option -$OPTARG requiert un argument." 1>&2
            usage
            ;;
    esac
done
shift $((OPTIND -1))

if [ $# -eq 0 ]; then
    usage
fi

project_dir="$(pwd)/project"

# Créer dossier si non-existant
mkdir -p "$project_dir"/{releases,shared/lib}

# Exécution de la commande appropriée
case "$1" in
    deploy)
        deploy
        ;;
    rollback)
        rollback
        ;;
    *)
        echo "Commande non reconnue: $1"
        usage
        ;;
esac