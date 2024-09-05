#!/bin/bash

# Fonction pour afficher l'aide
show_help() {
    echo "Utilisation: $0 [OPTIONS] COMMANDE"
    echo "Commandes:"
    echo "  deploy    Déploie une nouvelle version"
    echo "  rollback  Revient à la version précédente"
    echo "Options:"
    echo "  -k, --keep-last-x-releases NOMBRE  Nombre de releases à conserver (par défaut: 5)"
    echo "  -h, --help                         Afficher cette aide"
}

# Fonction pour obtenir la date courante au format YYYYMMDDHHmmss
get_current_date() {
    date +"%Y%m%d%H%M%S"
}

# Fonction pour créer des liens symboliques
create_symlinks() {
    local release_folder="project/releases/$1"
    find project/shared -type f | while read file; do
        local relative_path=${file#project/shared/}
        local target_dir="$release_folder/$(dirname "$relative_path")"
        mkdir -p "$target_dir"
        ln -s "$(realpath "$file")" "$release_folder/$relative_path"
    done
    echo "Liens symboliques créés pour les fichiers partagés."
}

# Fonction pour mettre à jour le lien "current"
update_current_link() {
    ln -sfn "releases/$1" project/current
    echo "Lien 'current' mis à jour vers $1"
}

# Fonction pour effectuer un rollback
do_rollback() {
    local current_release=$(readlink project/current | sed 's|releases/||')
    local previous_release=$(ls -1t project/releases | sed "1,/$current_release/d" | head -n 1)
    
    if [ -z "$previous_release" ]; then
        echo "Impossible d'effectuer un rollback. Aucune version précédente trouvée."
        return 1
    fi

    update_current_link $previous_release
    echo "Rollback effectué vers $previous_release"
}

# Initialisation des variables
keep_releases=5
command=""

# Traitement des options de ligne de commande
while getopts ":k:h-:" opt; do
    case $opt in
        k) keep_releases=$OPTARG ;;
        h) show_help; exit 0 ;;
        -)
            case "${OPTARG}" in
                keep-last-x-releases) 
                    keep_releases="${!OPTIND}"; OPTIND=$(( $OPTIND + 1 )) ;;
                help) show_help; exit 0 ;;
                *) echo "Option invalide: --$OPTARG" >&2; show_help; exit 1 ;;
            esac ;;
        \?) echo "Option invalide: -$OPTARG" >&2; show_help; exit 1 ;;
    esac
done

# Récupération de la commande
shift $((OPTIND - 1))
command=$1

# Exécution de la commande appropriée
case $command in
    deploy)
        echo "Déploiement d'une nouvelle version..."
        mkdir -p project/shared project/releases
        current_date=$(get_current_date)
        echo "Date courante: $current_date"
        mkdir -p "project/releases/$current_date"
        echo "Dossier de release créé: project/releases/$current_date"
        create_symlinks $current_date
        update_current_link $current_date
        
        echo "Suppression des anciennes releases..."
        cd project/releases
        ls -1t | tail -n +$((keep_releases + 1)) | xargs -r rm -rf
        echo "Nombre de dernières releases conservées: $keep_releases"
        ;;
    rollback)
        echo "Exécution du rollback..."
        do_rollback
        ;;
    *)
        echo "Commande invalide: $command"
        show_help
        exit 1
        ;;
esac

echo "Opération terminée avec succès!"
exit 0