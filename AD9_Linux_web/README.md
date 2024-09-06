# AD9 - Consolidation Linux pour le web

## Chaîner les commandes usuelles

Pour les exercices suivants, consignez la commande demandée dans un fichier, joignez éventuellement des caputures d'écran.

### Filtrer et compter des lignes

Lister tous les fichiers dans un répertoire.
Filtrer la liste pour ne montrer que les fichiers qui contiennent le mot "log" dans leur nom.
Compter combien de fichiers correspondent à ce critère.

_Tips_ : `wc`

### Rechercher un motif

Affichez chaque ligne dans tous les fichiers .txt d'un répertoire qui contient les code "500", et consignez les dans un nouveau fichier .log.

### Déplacer des fichiers

Cherchez tous les fichiers `.jpeg` dans une arborescence puis déplacez les dans un dossier `images`.

## Création d'un script de déploiement automatique

Le but de l'exercice est de créer un script shell qui déploie automatiquement un projet dans un dossier en suivant les bonnes pratiques Dev-Ops.
Pour les besoins du TP, nous exécuterons le script en local.

La structure de dossier à obtenir est la suivante :

```
| project
| \
|  | current > release/YYYYMMDDHHmmss
|  |
|  | releases
|  | \
|  |  | 20240905083000
|  |  | 20240904193000
|  |  | 20240903500000
|  |  | .....
|  |
|  | shared
|  | \
|  |  | mysupersecretproductionconfigfile.yaml
|  |  |
|  |  | lib
|  |  | \thecompanylegacynotversionnedlibrary
|  |
```

### Création de la structure du dossier

Créez votre script à la racine du dossier de votre TP, puis votre dossier projet et les sous-dossiers "shared" et "release".

Commencez par afficher la date courante dans le terminal au format YYYYMMDDHHmmss.
Utilisez ensuite cette création de date pour créer un sous-dossier dans "release" avec comme nom cette même date.

Afin d'éviter de stocker de trop nombreuses instances de projet, ajoutez une commande en fin de script qui supprime le dossier release à l'exception des 5 derniers dossiers créés. Modifiez votre script pour qu'une option puisse être passée au lancement pour modifier ce nombre de releases conservées, par exemple "--keep-last-x-releases".
**Tips** : utilisez la fonction Shell `getopts ":ab:c"`.

### Maitrise des liens

Le dossier "shared" sert à publier des fichiers non versionnés dans une release, comme par exemple des fichiers de configurations pour la production (pour des mots de passe ou des clés d'API par exemple).

Dans un premier temps, affichez récursivement dans le terminal tous les fichiers présents dans le dossier "shared".
Grâce à la commande précédente, copiez chacun de ces fichiers en suivant la même structure dans le dossier de release créé à l'étape 1.
Ce système bien que suffisant n'est pas satisfaisant : dupliquer des fichiers de configuration n'amène que des erreurs à terme. À la place, il est possible de créer des liens symboliques pour que seule une instance du fichier demeure dans le système. Modifiez votre script pour faire des liens vers les fichiers du dossier "shared"
**Tips** : `ln -s chemin_fichier_source chemin_fichier_cible`

Utilisez la même technique pour qu'il existe toujours un lien "current" vers la release en cours.
Dans un premier temps, le lien se fera sur la dernière release créée.

### Gestion d'erreurs

Modifiez votre script pour que l'on puisse donner une commande à votre script.
Créez les deux commandes "deploy" et "rollback", de manière à lancer votre script comme suit : `./mon_script.sh deploy`.

La commande "deploy" lance la création d'une nouvelle release etc..., pendant que la commande "rollback" va permettre de retourner à la version précédente.
Ajoutez cette fonctionnalité à votre script en modifiant le lien "current" pour qu'il pointe sur la release précédente.
**Tips** : `head` et `tails` permettent d'obtenir des éléments précis dans une liste.

Trouvez un moyen pour que plusieurs rollbacks successifs remontent toujours d'une version en arrière.

### Installation des sources

Déployer une application consiste toujours à installer une version du projet sur un serveur accessible aux clients finaux.
Ces versions sont quasi systématiquement hébergées sur un serveur Git, aussi votre script doit être capable de récupérer ces sources via Git.

Modifiez votre script pour qu'il teste si la commande `git` est accessible à l'utilisateur courant. Si oui, cloner le dossier `clone_me` de ce dépôt en tant que dossier de release.

Ensuite, pour que votre script soit portable, ajoutez des options pour pouvoir déployer :

- un dépôt Github/Gitlab précis
- une version précise (tag ou branche)
- un dossier précis du dépôt

**Tips** : `git clone [<options>] [--] <dépôt> [<répertoire>]`

Ces variables étant dépendantes de l'installation, il peut être commode d'utiliser des variables d'environnement à la place d'arguments dans le script (pour les valeurs par défaut).
Créez un fichier `.env` à la racine de l'installation pour paramétrer les variables par défaut.

**Tips** : `source .env`

## Solution Amirofcode

Nous avons créé un script de déploiement qui automatise le processus de déploiement d'un projet à partir d'un dépôt Git. Ce script suit les meilleures pratiques DevOps et inclut des fonctionnalités pour gérer les versions et les configurations.

### Fonctionnalités

- Clone un dépôt Git et une branche spécifiés
- Crée des répertoires de version horodatés
- Crée des liens symboliques pour les fichiers partagés dans chaque version
- Maintient un lien symbolique 'current' pointant vers la dernière version
- Prend en charge le retour aux versions précédentes
- Nettoie les anciennes versions, en gardant un nombre spécifié
- Utilise des variables d'environnement pour la configuration par défaut
- Permet des options en ligne de commande pour remplacer les paramètres par défaut

### Prérequis

- Shell Bash
- Git installé et accessible depuis la ligne de commande

### Configuration

1. Clonez ce dépôt sur votre machine locale.
2. Assurez-vous que le script de déploiement est exécutable :
   ```
   chmod +x Deployment_script.sh
   ```
3. Créez un fichier `.env` dans le même répertoire que le script avec le contenu suivant (ajustez si nécessaire) :
   ```
   GIT_REPO="https://github.com/Nyxis/ItAK-DFS31C.git"
   GIT_BRANCH="main"
   GIT_SUBDIRECTORY="AD9_Linux_web"
   KEEP_RELEASES=5
   ```

### Utilisation

Déploiement de base :

```
./Deployment_script.sh deploy
```

Déploiement personnalisé :

```
./Deployment_script.sh -r https://github.com/user/repo.git -b nom_branche -d sous_repertoire deploy
```

Retour à la version précédente :

```
./Deployment_script.sh rollback
```

Modifier le nombre de versions à conserver :

```
./Deployment_script.sh -k 3 deploy
```

### Options

- `-r` : Spécifie l'URL du dépôt Git
- `-b` : Spécifie la branche Git à utiliser
- `-d` : Spécifie le sous-répertoire du dépôt à déployer
- `-k` : Spécifie le nombre de versions récentes à conserver

### Note

Ce script est conçu à des fins éducatives et peut nécessiter des modifications supplémentaires pour une utilisation en production, telles qu'une gestion améliorée des erreurs et des mesures de sécurité.

### Build et rollback de l'application

La majorité des projets web actuels ont nécessairement besoin d'une mécanique dite de "build" pour des contraintes de performance principalement.
On parle de "build" pour télécharger des dépendances, générer des caches, compiler des fichiers (Typescript, SCSS...), minifier des assets, importer des scripts SQL, créer des images Docker...

Pour que votre script reste agnostique vis à vis d'une quelconque technologie, et donc rester portable, ajoutez une option `build` qui va référencer une ligne de commande à lancer pour déclencher le build.
Modifiez ensuite votre script pour lancer cette commande. Si un code d'erreur est renvoyé par le build, le script de déploiement doit s'arrêter immédiatement.

Si aucun build n'est défini, mais qu'un Makefile est présent à la racine du projet, proposez à l'utilisateur d'exécuter la commande `make` via un prompt (Y/n).

Dans le cas de rollback d'une version, des opérations internes à l'application peuvent avoir à être effectuées (purge de certains fichiers, scripts SQL...). Créer une option `rollback` dans votre script pour lancer ces opérations.

### Documentation

Toute script doit être documenté.
Créez donc une page de manuel (`man`) au format groff pour décrire les opérations disponibles, et leurs options.

__Tips__ : https://doc.ubuntu-fr.org/tutoriel/groff_tuto

Il est également commun et attendu que les options suivantes soient disponibles :
 - `-h` / `--help` : affiche les commandes et options disponibles
 - `-v` / `--verbose` : affiche des messages de debug
 - `-q` (quiet) : désactive l'affichage de tous les messages à l'exception des prompts
 - `-n` / `--no-interaction` : désactive les prompts en résolvant leur option par défaut (Yes dans notre cas)
 - `-V` / `--version` : donne la version sémantique du script (à cette étape du TP, vous êtes en version 1.0.0)

Implémentez et documentez ces options.
