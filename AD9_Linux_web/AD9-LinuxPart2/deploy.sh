#!/bin/bash

# Récupérer la date courante au format YYYYMMDDHHmmss
DATE=$(date +"%Y%m%d%H%M%S")

# Nombre de releases à conserver (par défaut : 5)
KEEP=5

# Gestion des options pour personnaliser le nombre de releases à conserver
while getopts ":k:" option; do
    case $option in
        k) KEEP=$OPTARG;;
        *) echo "Option invalide"; exit 1;;
    esac
done

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
