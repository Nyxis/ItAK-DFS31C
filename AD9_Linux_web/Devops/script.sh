#!/bin/bash

# Script simple pour le déploiement

# Fonction pour afficher l'aide
afficher_aide() {
    echo "Utilisation: $0 [OPTIONS]"
    echo "Options:"
    echo "  -k NOMBRE  Nombre de releases à conserver (par défaut: 5)"
    echo "  -h         Afficher cette aide"
}

# Fonction pour obtenir la date courante au format YYYYMMDDHHmmss
obtenir_date_courante() {
    date +"%Y%m%d%H%M%S"
}

# Initialisation de la variable pour le nombre de releases à conserver
garder_releases=5

# Traitement des options de ligne de commande
while getopts "k:h" option; do
    case $option in
        k) # Si l'option -k est spécifiée, on change le nombre de releases à conserver
            garder_releases=$OPTARG
            ;;
        h) # Si l'option -h est spécifiée, on affiche l'aide et on quitte
            afficher_aide
            exit 0
            ;;
        ?) # Si une option inconnue est spécifiée, on affiche une erreur
            echo "Option inconnue: -$OPTARG"
            afficher_aide
            exit 1
            ;;
    esac
done

# Création de la structure de dossiers
echo "Création de la structure de dossiers..."
mkdir -p project/shared project/releases

# Obtention de la date courante
date_courante=$(obtenir_date_courante)
echo "Date courante: $date_courante"

# Création du dossier de release
echo "Création du dossier pour la nouvelle release..."
mkdir -p "project/releases/$date_courante"
echo "Dossier de release créé: project/releases/$date_courante"

# Suppression des anciennes releases
echo "Suppression des anciennes releases..."
cd project/releases
# Obtention de la liste des releases à conserver
releases_a_garder=$(ls -1 | sort -r | head -n $garder_releases)
# Parcours de tous les dossiers de release
for release in *; do
    # Si le dossier n'est pas dans la liste à conserver, on le supprime
    if [[ ! $releases_a_garder =~ $release ]]; then
        rm -rf "$release"
        echo "Ancienne release supprimée: $release"
    fi
done

echo "Nombre de dernières releases conservées: $garder_releases"
echo "Déploiement terminé!"