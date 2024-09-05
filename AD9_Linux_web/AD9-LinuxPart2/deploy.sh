#!/bin/bash

# Nombre de releases à conserver (par défaut : 5)
KEEP=5

# Vérifier si une commande (deploy ou rollback) est donnée
if [ -z "$1" ]; then
    echo "Veuillez spécifier une commande : deploy ou rollback"
    exit 1
fi

COMMAND=$1

# Gestion des options pour personnaliser le nombre de releases à conserver
while getopts ":k:" option; do
    case $option in
        k) KEEP=$OPTARG;;
        *) echo "Option invalide"; exit 1;;
    esac
done

if [ "$COMMAND" == "deploy" ]; then
    # Partie déploiement (ce que tu as déjà fait)

    # Récupérer la date courante au format YYYYMMDDHHmmss
    DATE=$(date +"%Y%m%d%H%M%S")

    # Créer les dossiers de base
    mkdir -p project/releases
    mkdir -p project/shared/lib

    # Créer un sous-dossier dans "releases" avec la date courante
    mkdir -p "project/releases/$DATE"

    # Afficher la date courante pour vérification
    echo "Dossier de release créé : $DATE"

    # Supprimer les anciens dossiers de release, en gardant seulement les $KEEP derniers
    RELEASES=$(ls -dt project/releases/*)
    RELEASE_COUNT=$(echo "$RELEASES" | wc -l)

    if [ "$RELEASE_COUNT" -gt "$KEEP" ]; then
        OLD_RELEASES=$(echo "$RELEASES" | tail -n +$(($KEEP + 1)))
        echo "Suppression des releases suivantes :"
        echo "$OLD_RELEASES"
        rm -rf $OLD_RELEASES
    fi

    # Afficher récursivement les fichiers dans shared
    echo "Fichiers dans shared :"
    ls -R project/shared

    # Créer des liens symboliques pour les fichiers dans shared
    for file in $(find project/shared -type f); do
        ln -s "$file" "project/releases/$DATE/$(basename $file)"
    done

    # Créer un lien symbolique 'current' vers la dernière release
    ln -sfn "project/releases/$DATE" project/current
    echo "Le lien 'current' pointe vers : project/releases/$DATE"

elif [ "$COMMAND" == "rollback" ]; then
    # Partie rollback

    # Lister les releases par date décroissante
    RELEASES=$(ls -dt project/releases/*)

    # Vérifier qu'il y a au moins deux releases
    RELEASE_COUNT=$(echo "$RELEASES" | wc -l)
    if [ "$RELEASE_COUNT" -lt 2 ]; then
        echo "Pas assez de releases pour faire un rollback."
        exit 1
    fi

    # Trouver la release actuelle (vers laquelle 'current' pointe)
    CURRENT_RELEASE=$(readlink project/current)
    
    # Trouver la release précédente
    PREV_RELEASE=$(echo "$RELEASES" | grep -A 1 "$CURRENT_RELEASE" | tail -n 1)

    if [ -z "$PREV_RELEASE" ]; then
        echo "Aucune release précédente trouvée pour le rollback."
        exit 1
    fi

    # Mettre à jour le lien 'current' pour pointer vers la release précédente
    ln -sfn "$PREV_RELEASE" project/current
    echo "Le lien 'current' a été mis à jour pour pointer vers : $PREV_RELEASE"
else
    echo "Commande inconnue : $COMMAND. Utilisez 'deploy' ou 'rollback'."
    exit 1
fi
