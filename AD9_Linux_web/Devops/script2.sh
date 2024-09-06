#!/bin/bash

# Fonction pour afficher l'aide
afficher_aide() {
    echo "Utilisation: $0 [OPTIONS] COMMANDE"
    echo "Commandes:"
    echo "  deploy    Déploie une nouvelle version"
    echo "  rollback  Revient à la version précédente"
    echo "Options:"
    echo "  -k NOMBRE  Nombre de releases à conserver (par défaut: 5)"
    echo "  -h         Afficher cette aide"
}

# Fonction pour obtenir la date courante au format YYYYMMDDHHmmss
obtenir_date_courante() {
    date +"%Y%m%d%H%M%S"
}

# Fonction pour créer des liens symboliques
creer_liens_symboliques() {
    local dossier_release="project/releases/$1"
    for fichier in $(find project/shared -type f); do
        local chemin_relatif=${fichier#project/shared/}
        local dossier_cible="$dossier_release/$(dirname "$chemin_relatif")"
        mkdir -p "$dossier_cible"
        ln -s "$(realpath "$fichier")" "$dossier_release/$chemin_relatif"
    done
    echo "Liens symboliques créés pour les fichiers partagés."
}

# Fonction pour mettre à jour le lien "current"
mettre_a_jour_lien_current() {
    ln -sfn "releases/$1" project/current
    echo "Lien 'current' mis à jour vers $1"
}

# Initialisation des variables
garder_releases=5
commande=""

# Traitement des options de ligne de commande
while getopts "k:h" option; do
    case $option in
        k) garder_releases=$OPTARG ;;
        h) afficher_aide; exit 0 ;;
        ?) echo "Option invalide: -$OPTARG"; afficher_aide; exit 1 ;;
    esac
done

# Récupération de la commande
shift $((OPTIND - 1))
commande=$1

# Exécution de la commande appropriée
case $commande in
    deploy)
        echo "Déploiement d'une nouvelle version..."
        mkdir -p project/shared project/releases
        date_courante=$(obtenir_date_courante)
        echo "Date courante: $date_courante"
        mkdir -p "project/releases/$date_courante"
        echo "Dossier de release créé: project/releases/$date_courante"
        creer_liens_symboliques $date_courante
        mettre_a_jour_lien_current $date_courante
        
        echo "Suppression des anciennes releases..."
        cd project/releases
        ls -1t | tail -n +$((garder_releases + 1)) | xargs -r rm -rf
        echo "Nombre de dernières releases conservées: $garder_releases"
        ;;
    rollback)
        echo "Retour à la version précédente..."
        cd project/releases
        version_actuelle=$(basename $(readlink -f ../current))
        version_precedente=$(ls -1t | sed "1,/$version_actuelle/d" | head -n 1)
        if [ -z "$version_precedente" ]; then
            echo "Impossible de faire un rollback. Aucune version précédente trouvée."
            exit 1
        fi
        mettre_a_jour_lien_current $version_precedente
        echo "Rollback effectué vers la version: $version_precedente"
        ;;
    *)
        echo "Commande invalide: $commande"
        afficher_aide
        exit 1
        ;;
esac

echo "Opération terminée avec succès!"
exit 0