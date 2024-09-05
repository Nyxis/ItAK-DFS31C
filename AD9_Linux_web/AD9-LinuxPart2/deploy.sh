#!/bin/bash

# Récupérer la date courante au format YYYYMMDDHHmmss
DATE=$(date +"%Y%m%d%H%M%S")

# Créer les dossiers de base
mkdir -p project/releases
mkdir -p project/shared/lib

# Créer un sous-dossier dans "releases" avec la date courante
mkdir -p "project/releases/$DATE"

# Afficher la date courante pour vérification
echo "Dossier de release créé : $DATE"
