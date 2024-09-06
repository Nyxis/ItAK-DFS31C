#!/bin/bash

# Script de déploiement automatique simplifié

# Fonction pour afficher l'aide
afficher_aide() {
    echo "Utilisation: $0 [OPTIONS] COMMANDE"
    echo "Options:"
    echo "  -k NOMBRE   Nombre de versions à conserver (par défaut: 5)"
    echo "  -u URL      URL du dépôt Git (par défaut: depuis le fichier .env)"
    echo "  -b BRANCHE  Branche à cloner (par défaut: main)"
    echo "  -d DOSSIER  Dossier du dépôt à cloner (par défaut: AD9_Linux_web)"
    echo "  -h          Afficher cette aide"
    echo "Commandes:"
    echo "  deploy      Déployer une nouvelle version"
    echo "  rollback    Revenir à la version précédente"
}

# Fonction pour obtenir la date actuelle au format YYYYMMDDHHmmss
obtenir_date() {
    date +"%Y%m%d%H%M%S"
}

# Fonction pour vérifier si Git est installé
verifier_git() {
    if ! command -v git &> /dev/null; then
        echo "Git n'est pas installé. Veuillez l'installer et réessayer."
        exit 1
    fi
}

# Fonction pour cloner le dépôt Git
cloner_depot() {
    local url="$1"
    local dossier_cible="$2"
    local branche="$3"
    local sous_dossier="$4"
    
    git clone --depth 1 --branch "$branche" "$url" clone_temp
    mv "clone_temp/$sous_dossier" "$dossier_cible"
    rm -rf clone_temp
}

# Charger les variables d'environnement si le fichier .env existe
if [ -f .env ]; then
    source .env
fi

# Initialisation des paramètres par défaut
conserver_versions=5
repo_url=${DEFAULT_REPO_URL:-"https://github.com/SatiNotaDev/ItAK-DFS31C.git"}
repo_branche=${DEFAULT_REPO_BRANCH:-"main"}
repo_dossier=${DEFAULT_REPO_DIR:-"AD9_Linux_web"}

# Traitement des options de ligne de commande
while getopts "k:u:b:d:h" option; do
    case $option in
        k) conserver_versions=$OPTARG ;;
        u) repo_url=$OPTARG ;;
        b) repo_branche=$OPTARG ;;
        d) repo_dossier=$OPTARG ;;
        h) afficher_aide; exit 0 ;;
        ?) echo "Option inconnue: -$OPTARG"; afficher_aide; exit 1 ;;
    esac
done

shift $((OPTIND-1))
commande=$1

# Vérifier si une commande a été spécifiée
if [ -z "$commande" ]; then
    echo "Erreur: Aucune commande spécifiée."
    afficher_aide
    exit 1
fi

# Vérifier si Git est disponible
verifier_git

# Créer les dossiers nécessaires
mkdir -p projet/shared projet/releases

# Obtenir la date actuelle
date_actuelle=$(obtenir_date)

case $commande in
    deploy)
        echo "Déploiement d'une nouvelle version..."
        
        # Créer le dossier pour la nouvelle version
        mkdir -p "projet/releases/$date_actuelle"
        
        # Cloner le dépôt
        echo "Clonage du dépôt $repo_url (branche $repo_branche, dossier $repo_dossier) dans projet/releases/$date_actuelle"
        cloner_depot "$repo_url" "projet/releases/$date_actuelle" "$repo_branche" "$repo_dossier"
        
        # Copier les fichiers partagés
        echo "Copie des fichiers partagés..."
        cp -rs projet/shared/* "projet/releases/$date_actuelle/" 2>/dev/null || true
        
        # Mettre à jour le lien symbolique "current"
        ln -snf "releases/$date_actuelle" projet/current
        echo "Lien symbolique 'current' mis à jour vers la nouvelle version"
        ;;
    
    rollback)
        echo "Retour à la version précédente..."
        version_precedente=$(ls -1d projet/releases/* | sort -r | sed -n 2p)
        if [ -n "$version_precedente" ]; then
            ln -snf "$version_precedente" projet/current
            echo "Retour effectué vers $(basename $version_precedente)"
        else
            echo "Aucune version précédente trouvée pour effectuer le retour."
        fi
        ;;
    
    *)
        echo "Commande inconnue: $commande"
        afficher_aide
        exit 1
        ;;
esac

# Supprimer les anciennes versions
echo "Suppression des anciennes versions..."
cd projet/releases
versions_a_conserver=$(ls -1 | sort -r | head -n $conserver_versions)
for version in *; do
    if [[ ! $versions_a_conserver =~ $version ]]; then
        rm -rf "$version"
        echo "Ancienne version supprimée: $version"
    fi
done

echo "Nombre de versions conservées: $conserver_versions"
echo "Opération terminée!"
