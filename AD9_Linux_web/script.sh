#!/bin/bash
set -eu

# Définition des variables globales
PROJET=$(realpath "./project")
NOMBRE_VERSIONS=5
DATE=$(date +%Y%m%d%H%M%S)

# Fonction pour afficher l'aide
usage() {
    echo "Usage: $0 [-n nombre] {deploy|rollback}" >&2
    echo "  -n nombre : Garder 'nombre' versions (par défaut: $NOMBRE_VERSIONS)" >&2
    exit 1
}

# Vérification de l'existence du projet
if [ ! -d "$PROJET" ]; then
    echo "Erreur : Le dossier du projet n'existe pas." >&2
    exit 1
fi

# Traitement des options de ligne de commande
while getopts "n:" opt; do
    case $opt in
        n)
            # Vérification que l'argument de -n est un nombre entier positif
            if [[ $OPTARG =~ ^[0-9]+$ ]] && [ "$OPTARG" -gt 0 ]; then
                NOMBRE_VERSIONS=$OPTARG
            else
                echo "Erreur : -n requiert un nombre entier positif supérieur à 0" >&2
                usage
            fi
            ;;
        \?)
            echo "Option invalide: -$OPTARG" >&2
            usage
            ;;
    esac
done

shift $((OPTIND-1))

# Vérification qu'une commande (deploy ou rollback) a été fournie
[ $# -eq 0 ] && usage

case $1 in
    deploy)
        RELEASE_DIR="$PROJET/release/$DATE"
        mkdir -p "$RELEASE_DIR"
        
        # Recréation de la structure des dossiers sans inclure 'shared'
        cd "$PROJET/shared" || exit 1
        find . -type d -not -path . | while read -r dir; do
            mkdir -p "$RELEASE_DIR/$dir"
        done
        
        # Création des liens symboliques pour les fichiers
        find . -type f | while read -r file; do
            mkdir -p "$RELEASE_DIR/$(dirname "$file")"
            ln -s "$PROJET/shared/$file" "$RELEASE_DIR/$file"
        done
        
        # Mise à jour du lien 'current' vers la nouvelle release
        ln -sfn "$RELEASE_DIR" "$PROJET/current"
        echo "Nouvelle version déployée: $DATE"
        
        # Suppression des anciennes versions en gardant le nombre spécifié
        cd "$PROJET/release" || exit 1
        if [ "$(ls -1 | wc -l)" -gt "$NOMBRE_VERSIONS" ]; then
            ls -t | tail -n +"$((NOMBRE_VERSIONS + 1))" | xargs -r rm -rf
            echo "Conservation des $NOMBRE_VERSIONS versions les plus récentes."
        else
            echo "Nombre de versions actuel inférieur ou égal à $NOMBRE_VERSIONS. Aucune suppression nécessaire."
        fi
        ;;
    rollback)
        # Gestion des versions précédente et mise à jour du lien symbolique
        previous=$(ls -t "$PROJET/release" | sed -n 2p)
        if [ -n "$previous" ]; then
            ln -sfn "$PROJET/release/$previous" "$PROJET/current"
            echo "Retour à la version: $previous"
        else
            echo "Pas de version précédente disponible" >&2
            exit 1
        fi
        ;;
    *)
        usage
        ;;
esac
