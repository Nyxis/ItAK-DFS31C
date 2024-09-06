#!/bin/bash

# Configuration
PROJECT_DIR="project"
RELEASES_DIR="$PROJECT_DIR/releases"
SHARED_DIR="$PROJECT_DIR/shared"
CURRENT_DIR="$PROJECT_DIR/current"
DEFAULT_KEEP=5

# Affiche la date courante au format YYYYMMDDHHmmss
DATE=$(date +"%Y%m%d%H%M%S")

# Gestion des options
KEEP_LAST=$DEFAULT_KEEP
COMMAND="deploy"

while getopts ":c:k:" opt; do
  case ${opt} in
    k )
      KEEP_LAST=$OPTARG
      ;;
    c )
      COMMAND=$OPTARG
      ;;
    \? )
      echo "Invalid option: $OPTARG" 1>&2
      exit 1
      ;;
    : )
      echo "Invalid option: $OPTARG requires an argument" 1>&2
      exit 1
      ;;
  esac
done

# Fonction pour créer les dossiers requis
create_directories() {
    mkdir -p "$RELEASES_DIR/$DATE"
    mkdir -p "$SHARED_DIR/lib"
    touch "$SHARED_DIR/mysupersecretproductionconfigfile.yaml"
    touch "$SHARED_DIR/lib/thecompanylegacynotversionnedlibrary"
}

# Fonction pour afficher les fichiers du dossier shared
list_shared_files() {
    echo "Liste des fichiers partagés :"
    find "$SHARED_DIR" -type f
}

# Fonction pour créer des liens symboliques pour les fichiers partagés
link_shared_files() {
    for file in $(find "$SHARED_DIR" -type f); do
        # Construction du chemin relatif manuellement
        relative_path="${file#$SHARED_DIR/}"
        target_dir="$RELEASES_DIR/$DATE/$(dirname "$relative_path")"
        
        # Création du dossier cible s'il n'existe pas
        mkdir -p "$target_dir"

        # Création du lien symbolique
        ln -s "$file" "$target_dir/$(basename "$file")"
    done
}

# Fonction pour mettre à jour le lien current vers la dernière release
update_current_link() {
    ln -sfn "$RELEASES_DIR/$DATE" "$CURRENT_DIR"
}

# Fonction pour déployer une nouvelle release
deploy() {
    echo "Déploiement de la release $DATE ..."
    create_directories
    list_shared_files
    link_shared_files
    update_current_link
    cleanup_old_releases
    echo "Déploiement terminé."
}

# Fonction pour supprimer les anciennes releases et conserver les X dernières
cleanup_old_releases() {
    echo "Nettoyage des anciennes releases, en conservant les $KEEP_LAST dernières ..."
    ls -dt "$RELEASES_DIR"/* | tail -n +$(($KEEP_LAST + 1)) | xargs rm -rf
}

# Fonction pour effectuer un rollback à la version précédente
rollback() {
    PREV_RELEASE=$(ls -dt "$RELEASES_DIR"/* | head -n 2 | tail -n 1)
    if [ -n "$PREV_RELEASE" ]; then
        ln -sfn "$PREV_RELEASE" "$CURRENT_DIR"
        echo "Rollback effectué. Current pointe désormais vers $(basename "$PREV_RELEASE")"
    else
        echo "Impossible de rollback. Aucune version précédente trouvée."
    fi
}

# Exécution de la commande en fonction de l'argument
case $COMMAND in
    deploy)
        deploy
        ;;
    rollback)
        rollback
        ;;
    *)
        echo "Commande inconnue : $COMMAND"
        echo "Utilisez './deploy.sh -c deploy' ou './deploy.sh -c rollback'"
        ;;
esac
