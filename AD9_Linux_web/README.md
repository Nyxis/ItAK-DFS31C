# AD9 - Consolidation Linux pour le web

## Chaîner les commandes usuelles

Pour les exercices suivants, consignez la commande demandée dans un fichier, joignez éventuellement des caputures d'écran.

### Filtrer et compter des lignes

Lister tous les fichiers dans un répertoire.
Filtrer la liste pour ne montrer que les fichiers qui contiennent le mot "log" dans leur nom.
Compter combien de fichiers correspondent à ce critère.

_Tips_ : ```wc```

### Rechercher un motif

Affichez chaque ligne dans tous les fichiers .txt d'un répertoire qui contient les code "500", et consignez les dans un nouveau fichier .log.

### Déplacer des fichiers

Cherchez tous les fichiers ```.jpeg``` dans une arborescence puis déplacez les dans un dossier ```images```.

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
__Tips__ : utilisez la fonction Shell `getopts ":ab:c"`.

### Maitrise des liens

Le dossier "shared" sert à publier des fichiers non versionnés dans une release, comme par exemple des fichiers de configurations pour la production (pour des mots de passe ou des clés d'API par exemple).

Dans un premier temps, affichez récursivement dans le terminal tous les fichiers présents dans le dossier "shared".
Grâce à la commande précédente, copiez chacun de ces fichiers en suivant la même structure dans le dossier de release créé à l'étape 1.
Ce système bien que suffisant n'est pas satisfaisant : dupliquer des fichiers de configuration n'amène que des erreurs à terme. À la place, il est possible de créer des liens symboliques pour que seule une instance du fichier demeure dans le système. Modifiez votre script pour faire des liens vers les fichiers du dossier "shared"
__Tips__ : `ln -s chemin_fichier_source chemin_fichier_cible`

Utilisez la même technique pour qu'il existe toujours un lien "current" vers la release en cours.
Dans un premier temps, le lien se fera sur la dernière release créée.

### Gestion d'erreurs

Modifiez votre script pour que l'on puisse donner une commande à votre script.
Créez les deux commandes "deploy" et "rollback", de manière à lancer votre script comme suit : `./mon_script.sh deploy`.

La commande "deploy" lance la création d'une nouvelle release etc..., pendant que la commande "rollback" va permettre de retourner à la version précédente.
Ajoutez cette fonctionnalité à votre script en modifiant le lien "current" pour qu'il pointe sur la release précédente.
__Tips__ : `head` et `tails` permettent d'obtenir des éléments précis dans une liste.

Trouvez un moyen pour que plusieurs rollbacks successifs remontent toujours d'une version en arrière.

## Solution 

Nous avons créé un script de déploiement qui répond à toutes les exigences spécifiées dans l'exercice. Voici un aperçu des fonctionnalités implémentées et comment utiliser le script :

### Fonctionnalités Implémentées

1. Création de la structure de répertoire requise (project, releases, shared).
2. Horodatage automatique des nouvelles releases.
3. Création de liens symboliques pour les fichiers partagés.
4. Lien symbolique 'current' pointant vers la dernière release.
5. Nettoyage des anciennes releases, ne gardant qu'un nombre spécifié (par défaut 5).
6. Fonctionnalités de déploiement et de rollback.
7. Option pour spécifier le nombre de releases à conserver.

### Comment Utiliser le Script

1. Assurez-vous que le script est exécutable :
   ```
   chmod +x Deployment_script.sh
   ```

2. Pour déployer une nouvelle release :
   ```
   ./Deployment_script.sh deploy
   ```

3. Pour effectuer un rollback vers la release précédente :
   ```
   ./Deployment_script.sh rollback
   ```

4. Pour spécifier le nombre de releases à conserver (par exemple, 3) :
   ```
   ./Deployment_script.sh -k 3 deploy
   ```

### Structure et Fonctionnalité du Script

- Le script crée un répertoire horodaté pour chaque nouvelle release.
- Les fichiers partagés sont liés symboliquement dans chaque répertoire de release.
- Le lien symbolique 'current' est mis à jour pour pointer vers la dernière release après chaque déploiement.
- La fonctionnalité de rollback permet de revenir à la release précédente.
- Les anciennes releases sont automatiquement nettoyées, ne gardant que le nombre spécifié de releases récentes.

### Gestion des Erreurs et Cas Particuliers

- Le script vérifie l'existence des répertoires nécessaires.
- Il gère les cas où il n'y a pas de releases précédentes pour le rollback.
- L'analyse des arguments de ligne de commande est implémentée pour spécifier le nombre de releases à conserver.

### Améliorations Potentielles

- Implémenter la journalisation pour toutes les actions effectuées par le script.
- Ajouter un mode de simulation pour simuler le déploiement sans effectuer de changements.
- Améliorer la gestion des erreurs et ajouter des messages d'erreur plus détaillés.
- Implémenter une fonctionnalité de rollback multiple pour revenir en arrière de plusieurs versions à la fois.

En suivant ces étapes et en utilisant le script fourni, nous avons créé un système de déploiement robuste qui suit les meilleures pratiques DevOps pour la gestion des releases et des configurations.

### Installation des sources

Déployer une application consiste toujours à installer une version du projet sur un serveur accessible aux clients finaux.
Ces versions sont quasi systématiquement hébergées sur un serveur Git, aussi votre script doit être capable de récupérer ces sources via Git.

Modifiez votre script pour qu'il teste si la commande `git` est accessible à l'utilisateur courant. Si oui, cloner le dossier `clone_me` de ce dépôt en tant que dossier de release.

Ensuite, pour que votre script soit portable, ajoutez des options pour pouvoir déployer :
 - un dépôt Github/Gitlab précis
 - une version précise (tag ou branche)
 - un dossier précis du dépôt

__Tips__ : `git clone [<options>] [--] <dépôt> [<répertoire>]`

Ces variables étant dépendantes de l'installation, il peut être commode d'utiliser des variables d'environnement à la place d'arguments dans le script (pour les valeurs par défaut).
Créez un fichier `.env` à la racine de l'installation pour paramétrer les variables par défaut.

__Tips__ : `source .env`
