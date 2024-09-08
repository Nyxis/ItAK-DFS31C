# Script de Déploiement Automatisé

Ce projet contient un script de déploiement automatisé flexible pour des projets basés sur Git. Il permet de déployer facilement n'importe quel dépôt Git, de gérer les versions, et d'effectuer des rollbacks si nécessaire.

## Fonctionnalités

- Clonage de n'importe quel dépôt Git spécifié
- Création de répertoires de version horodatés
- Gestion des liens symboliques pour les fichiers partagés
- Prise en charge des commandes de build personnalisées
- Possibilité de déployer un sous-répertoire spécifique du dépôt
- Nettoyage automatique des anciennes versions
- Fonctionnalité de rollback avec commande personnalisable
- Options pour le mode verbeux, silencieux et sans interaction

## Prérequis

- Bash shell
- Git installé et accessible depuis la ligne de commande

## Installation

1. Clonez ce dépôt sur votre machine locale.
2. Assurez-vous que le script de déploiement est exécutable :
   ```
   chmod +x Deployment_script.sh
   ```
3. Créez un fichier `.env` dans le même répertoire que le script avec le contenu suivant (ajustez si nécessaire) :
   ```
   GIT_REPO="https://github.com/votre_utilisateur/votre_repo.git"
   GIT_BRANCH="main"
   GIT_SUBDIRECTORY=""
   KEEP_RELEASES=5
   ```

## Utilisation

### Déploiement de base

```bash
./Deployment_script.sh -r https://github.com/utilisateur/repo.git deploy
```

### Déploiement personnalisé

```bash
./Deployment_script.sh -r https://github.com/utilisateur/repo.git -b develop -d backend -B "npm run build" -k 3 deploy
```

### Rollback

```bash
./Deployment_script.sh -R "php artisan migrate:rollback" rollback
```

## Options

- `-k NUM` : Nombre de versions récentes à conserver (défaut : 5)
- `-r URL` : URL du dépôt Git (requis pour le déploiement)
- `-b BRANCH` : Branche Git à utiliser (défaut : main)
- `-d DIR` : Sous-répertoire du dépôt à déployer (optionnel)
- `-B CMD` : Commande de build à exécuter lors du déploiement
- `-R CMD` : Commande de rollback à exécuter lors du rollback
- `-h, --help` : Afficher le message d'aide
- `-v, --verbose` : Afficher les messages de débogage
- `-q, --quiet` : Désactiver toute sortie sauf les prompts
- `-n, --no-interaction` : Désactiver les prompts (utiliser les réponses par défaut)
- `-V, --version` : Afficher la version du script

## Documentation

Une page de manuel détaillée est disponible. Pour la consulter, utilisez :

```bash
man ./Deployment_script.1
```

## Structure du Projet

```
project/
├── current -> ./releases/YYYYMMDDHHMMSS
├── releases/
│   ├── 20240906120000/
│   ├── 20240905180000/
│   └── ...
└── shared/
    └── config.yml
```

## Contribution

Les contributions à ce projet sont les bienvenues. N'hésitez pas à ouvrir une issue ou à soumettre une pull request.

## Licence

Ce projet est sous licence GPL-3.0. Voir le fichier `LICENSE` pour plus de détails.
