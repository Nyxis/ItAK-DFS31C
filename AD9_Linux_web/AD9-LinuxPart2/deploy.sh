
#!/bin/bash

echo "Répertoire courant : $(pwd)"

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

# Variables pour les options
VERSION="1.0.0"
VERBOSE=0
QUIET=0
NO_INTERACTION=0

# Fonction pour afficher l'aide
function show_help {
    echo "Usage: $0 [options] [deploy|rollback]"
    echo ""
    echo "Options:"
    echo "  -h, --help            Affiche cette aide."
    echo "  -v, --verbose         Affiche des messages de debug."
    echo "  -q                    Mode silencieux, n'affiche que les messages importants."
    echo "  -n, --no-interaction   Désactive les prompts et utilise les réponses par défaut."
    echo "  -V, --version         Affiche la version du script."
}

# Fonction pour afficher la version
function show_version {
    echo "$0 version $VERSION"
}

# Gestion des options de documentation
while [[ "$#" -gt 0 ]]; do
    case $1 in
        -h|--help) show_help; exit 0;;
        -v|--verbose) VERBOSE=1;;
        -q) QUIET=1;;
        -n|--no-interaction) NO_INTERACTION=1;;
        -V|--version) show_version; exit 0;;
        *) break;;
    esac
    shift
done

# Vérifier si une commande (deploy ou rollback) est donnée
if [ -z "$1" ]; then
    echo "Veuillez spécifier une commande : deploy ou rollback"
    exit 1
fi

COMMAND=$1


# Nombre de releases à conserver (par défaut : 5)
KEEP=5
BUILD_COMMAND=""
NO_INTERACTION=0

# Vérifier si une commande (deploy ou rollback) est donnée
if [ -z "$1" ]; then
    echo "Veuillez spécifier une commande : deploy ou rollback"
    exit 1
fi

COMMAND=$1

# Gestion des options pour personnaliser le nombre de releases à conserver, le dépôt, la branche/tag, et le répertoire de déploiement
while getopts ":k:r:b:d:n:" option; do
    case $option in
        k) KEEP=$OPTARG;;  # Nombre de releases à garder
        r) REPO_URL=$OPTARG;;  # Dépôt Git à cloner
        b) BRANCH_OR_TAG=$OPTARG;;  # Branche ou tag à cloner
        d) TARGET_DIR=$OPTARG;;  # Répertoire cible de déploiement
        n) NO_INTERACTION=1;;  # Pas de prompt d'interaction
        *) echo "Option invalide"; exit 1;;
    esac
done



# Fonction pour exécuter le build
function run_build {
    # On définit le chemin du Makefile dynamiquement en fonction de la release actuelle
    MAKEFILE_DIR="$RELEASE_DIR/$CLONE_DIR/clone_me"


    if [ -n "$BUILD_COMMAND" ]; then
        echo "Exécution de la commande de build : $BUILD_COMMAND"
        eval "$BUILD_COMMAND"
        if [ $? -ne 0 ]; then
            echo "Erreur lors du build, arrêt du déploiement."
            exit 1
        fi
    elif [ -f "$MAKEFILE_DIR/Makefile" ]; then
        # Si un Makefile est trouvé dans le répertoire spécifié
        if [ "$NO_INTERACTION" -eq 1 ]; then
            RESPONSE="y"
        else
            read -p "Un Makefile est détecté dans $MAKEFILE_DIR. Voulez-vous exécuter 'make' ? (Y/n) " RESPONSE
        fi

        if [[ "$RESPONSE" == "y" || "$RESPONSE" == "Y" || "$RESPONSE" == "" ]]; then
            echo "Exécution de la commande 'make' dans $MAKEFILE_DIR"
            (cd "$MAKEFILE_DIR" && make)
            if [ $? -ne 0 ]; then
                echo "Erreur lors de l'exécution de 'make', arrêt du déploiement."
                exit 1
            fi
        fi
    else
        echo "Aucune commande de build définie, et aucun Makefile trouvé dans $MAKEFILE_DIR."
    fi
}



# Fonction pour exécuter des opérations spécifiques lors du rollback
function run_rollback_operations {
    echo "Exécution des opérations internes de rollback..."
    # Exemple : Purge de fichiers, scripts SQL, etc.
    # Ajouter les opérations spécifiques ici
    # rm -rf tmp/cache/  # Exemple de purge de fichiers cache
}

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
git sparse-checkout set "AD9_Linux_web/clone_me"

    # Récupérer uniquement le sous-dossier
  git pull origin "$BRANCH_OR_TAG"

# Ajout pour vérifier si le sous-dossier clone_me a bien été cloné
echo "Vérification du contenu après clonage :"
ls -l "$RELEASE_DIR/$CLONE_DIR"


    # Suppression manuelle des fichiers non désirés (sauf le sous-dossier)
    find . -maxdepth 1 ! -name "$CLONE_DIR" -type f -exec rm -f {} \;
    find . -maxdepth 1 ! -name "$CLONE_DIR" -type d -exec rm -rf {} \;
    

    # Exécuter le build après avoir récupéré les fichiers
    run_build

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

    # Exécuter les opérations internes spécifiques du rollback
    run_rollback_operations

else
    echo "Commande inconnue : $COMMAND. Utilisez 'deploy' ou 'rollback'."
    exit 1
fi
