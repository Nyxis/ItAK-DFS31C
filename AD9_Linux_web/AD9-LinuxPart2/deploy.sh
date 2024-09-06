#!/bin/bash

# Charger les variables d'environnement à partir du fichier .env
if [ -f .env ]; then
    source .env
else
    echo ".env non trouvé, veuillez créer un fichier .env avec les variables REPO_URL, BRANCH_OR_TAG, TARGET_DIR, et CLONE_DIR."
    exit 1
fi

# Vérifier si git est installé
if ! command -v git &> /dev/null
then
    echo "Git n'est pas installé. Veuillez l'installer avant de continuer."
    exit 1
fi

# Nombre de releases à conserver (par défaut : 5)
KEEP=5

# Vérifier si une commande (deploy ou rollback) est donnée
if [ -z "$1" ]; then
    echo "Veuillez spécifier une commande : deploy ou rollback"
    exit 1
fi

COMMAND=$1

# Gestion des options pour personnaliser le nombre de releases à conserver, le dépôt, la branche/tag, et le répertoire de déploiement
while getopts ":k:r:b:d:" option; do
    case $option in
        k) KEEP=$OPTARG;;  # Nombre de releases à garder
        r) REPO_URL=$OPTARG;;  # Dépôt Git à cloner
        b) BRANCH_OR_TAG=$OPTARG;;  # Branche ou tag à cloner
        d) TARGET_DIR=$OPTARG;;  # Répertoire cible de déploiement
        *) echo "Option invalide"; exit 1;;
    esac
done

if [ "$COMMAND" == "deploy" ]; then
    # Partie déploiement

    # Récupérer la date courante au format YYYYMMDDHHmmss
    DATE=$(date +"%Y%m%d%H%M%S")

    # Créer les dossiers de base
    mkdir -p "$TARGET_DIR"
    mkdir -p project/shared/lib

    # Créer un sous-dossier dans "releases" avec la date courante
    RELEASE_DIR="$TARGET_DIR/$DATE"
    mkdir -p "$RELEASE_DIR"

    # Initialiser un dépôt Git vide dans le répertoire de la release
    cd "$RELEASE_DIR"
    git init
    git remote add origin "$REPO_URL"
    git fetch --depth 1 origin "$BRANCH_OR_TAG"

    # Activer le sparse-checkout pour ne cloner que le sous-dossier souhaité
    git sparse-checkout init --cone
    git sparse-checkout set "$CLONE_DIR/"

    # Récupérer uniquement le sous-dossier
    git pull origin "$BRANCH_OR_TAG"

    # Suppression manuelle des fichiers non désirés (sauf le sous-dossier)
    find . -maxdepth 1 ! -name "$CLONE_DIR" -type f -exec rm -f {} \;
    find . -maxdepth 1 ! -name "$CLONE_DIR" -type d -exec rm -rf {} \;

    # Revenir au répertoire initial
    cd -

    # Supprimer les anciens dossiers de release, en gardant seulement les $KEEP derniers
    RELEASES=$(ls -dt "$TARGET_DIR"/*)
    RELEASE_COUNT=$(echo "$RELEASES" | wc -l)

    if [ "$RELEASE_COUNT" -gt "$KEEP" ]; then
        OLD_RELEASES=$(echo "$RELEASES" | tail -n +$(($KEEP + 1)))
        echo "Suppression des releases suivantes :"
        echo "$OLD_RELEASES"
        rm -rf $OLD_RELEASES
    fi

    # Créer des liens symboliques pour les fichiers dans shared
    for file in $(find project/shared -type f); do
        ln -s "$file" "$RELEASE_DIR/$(basename $file)"
    done

    # Créer un lien symbolique 'current' vers la dernière release
    ln -sfn "$RELEASE_DIR" project/current
    echo "Le lien 'current' pointe vers : $RELEASE_DIR"

elif [ "$COMMAND" == "rollback" ]; then
    # Partie rollback

    # Lister les releases par date décroissante
    RELEASES=$(ls -dt "$TARGET_DIR"/*)

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
