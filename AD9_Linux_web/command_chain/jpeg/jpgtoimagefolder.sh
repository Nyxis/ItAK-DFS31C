#!/bin/bash

# Déplacer tous les fichiers .jpg des sous-répertoires vers le dossier image
find . -type f -name "*.jpg" -exec mv {} image/ \;

# Afficher un message de confirmation
echo "Tous les fichiers .jpg ont été déplacés vers le dossier 'image'."