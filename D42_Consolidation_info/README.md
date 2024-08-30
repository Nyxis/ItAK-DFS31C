# D42 - Consolidation des compétences en développement informatique

Disposer d'un outil efficient et sécurisé est important pour tout artisan.
Aussi, s'assurer de la portabilité de son environnement de travail tout en maintenant une relative confidentialité est l'un des enjeux principaux d'un développeur, en particulier quand son travail n'est pas sédentaire.
De plus, partager son travail avec d'autre développeurs est nécessaire dans la plupart des projets et s'assurer que chacun travaille avec les mêmes versions des outils est un enjeux majeur.

Dans ce TP, nous allons automatiser la mise en place d'un espace de travail isolé et portable.

Pour la totalité du TP, nous devons travailler dans un dossier isolé du reste des autres fichiers, utiliser le dossier `~/Workspace/It-Akademy/` est fortement conseillé. Dans la suite du TP, ce dossier sera nommé "votre workspace".

## Utilisation de Makefile

Make est un programme utilisé pour créer des fichiers et dossiers via des recettes.
Chaque recette peut en dépendre d'une autre, qui sera exécutée si nécessaire lors du lancement du programme. Ces recettes sont définies dans un fichier Makefile, qui est lu par défaut lorsqu'on lance la commande Make dans un dossier.

```Makefile
data:
    mkdir data

data/dummies.sql: data
    wget -O data/dummies.sql https://api.la_production_ultra_secure.fr/data.sql

install: data/dummies.sql
    @echo "Projet installé !"
```

`make install` va d'abord appeller "data/dummies.sql", qui va appeler "data" puis enfin le corps de la recette "install".
De plus, si le dossier "data" existe déjà, Make va ignorer la recette, vu qu'il ne reste rien à faire.


### Premières créations

Créez un fichier `Makefile` dans votre workspace.
Comme première instruction, ordonnez la création d'un dossier .ssh et d'un dossier .git dans votre workspace.

Ces deux recettes doivent être des dépendances d'une recette principale que nous appelerons `install`.

Ajoutez ensuite une recette pour géréner une paire de clés SSH pour votre workspace dans le dossier `.ssh`. Nommez ces clés `it_akademy_rsa`.

Tips : `ssh-keygen -q -f <chemin_vers_le_dossier>/it_akademy_rsa`

Enregistrez maintenant cette clé dans votre compte Github (Settings/SSH & GPG Keys).

Créez maintenant la recette pour le fichier `.git/config`.
Ce fichier doit contenir les éléments suivants :
```
[user]
    name = <votre_nom>
    email = <votre_email>
[core]
    sshCommand = "ssh -i <chemin_absolu_de_votre_workspace>/.ssh/it_akademy_rsa"
```

Utilisez les redirections de sortie standard vues en cours pour générer le contenu du fichier (`echo "hello" > world.txt`).

Tips : utilisez les caratères "\n" (retour à la ligne) et "\t" (tabulation) dans une chaine de caractère pour gérer la mise en forme du fichier.

Vos informations personnelles ainsi que le chemin de la clé privée sont écrits "en dûr" dans votre Makefile, ne le rendant absolument pas portable ni réutilisable.

## Utilisation de variables

Makefile supporte la définition de variables, nous allons les utiliser pour dynamiser le script.

Pour commencer, créez un fichier `.env` dans votre workspace. Il s'agit de variables d'environnement (propres à votre installation, par convention).
Dans ce fichier, définissez vos variables :
```env
USER_NAME=<votre_nom>
USER_EMAIL=<votre_email>
```
Incluez maintenant le fichier de variables en haut de votre Makefile via l'instruction `include`.
Vous avez maintenant accès aux variables `$(USER_NAME)` et `$(USER_EMAIL)` dans vos recettes, utilisez les pour remplacer les valeurs en dur.

Il est également possible de stocker le résultat d'une commande shell dans une variable de Makefile, ex : `ma_var ?= $(shell ls -al /)`. En stockant le résultat de la commande renvoyant le chemin absolu du dossier courant ou du fichier de la clé, il va être possible de rendre dynamique le chemin de la clé SSH lors de la génération du fichier `.git/config`.

Tips : utilisez le chaînage de commandes pour faciliter vos tests : `rm -rf .git; make install` par exemple.

Enfin, il va être nécessaire de forcer Git à utiliser le fichier de configuration généré, mais uniquement dans votre workspace.
Modifiez la recette du fichier .git/config pour ajouter l'instruction suivante à votre fichier de configuration général `~/.gitconfig` :
```
[includeif "gitdir:<chemin_absolu_de_votre_workspace>"]
    path=<chemin_absolu_de_votre_workspace>/.git/config
```
Attention : n'ajoutez cette ligne uniquement si elle n'est pas présente dans le fichier.

Tips : utilisez les commandes cat, grep, |, >> et l'opérateur || pour simuler une instruction logique "if".

### Portabilité

To be continued...


## Docker

Afin d'exécuter vos programmes, vous avez besoin d'outils comme un serveur web, un interpréteur de langages, un moteur de base de données, un générateur d'images etc...

Docker permet d'installer, d'exécuter et d'ordonnancer ces programmes à partir de simples fichiers de configuration, indépendants du système d'exploitation.

### Docker-compose

Docker-compose est un sous programme de Docker permettant de définir des containers et de les lier entre eux.

Créez un fichier docker-compose.yml.
Dans ce fichier, définissez un service "web" qui devra simplement accepter des connections sur le port 80, et afficher la page par défaut du serveur.

Vous pouvez utiliser Apache ou Nginx au choix.

Tips : utilisez les commandes `docker-compose up` pour démarrer et `down` pour stopper vos conteneurs.

La force de Docker est de permettre à des systèmes isolés de



