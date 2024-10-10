# D70 - Git / Github / systèmes de versioning

## Apprentissage des commandes usuelles

Effectuez les exercices du sandbox Git https://learngitbranching.js.org/?locale=fr_FR.

À chaque exercice, prenez une capture d'écran ou recopiez les commandes utilisées pour accomplir l'objectif; puis ajoutez les à une archive en réponse du devoir sur l'espace Classroom, ou directement dans votre dépôt après l'étape "Travailler à partir d'un repository existant" du TP.

## Setup pro d'un compte Git

Dans cet exercice, nous allons mettre en place des bonnes pratiques pour utiliser Git et Github, et plus généralement travailler rigoureusement.

### Mettre à jour vos paquets et librairies

En développement, nous utilisons beaucoup de petits programmes et logiciels pour nous simplifier le travail. Seulement, vu qu'ils sont pour la plupart open-source, les mises à jour sont régulières et importantes et comblent pour la plupart des failles de sécurité : il est donc nécessaire de les maintenir à jour.

Selon votre système, vous pouvez gérer vos paquets via les programmes suivants :
  - Unix : [Apt-get](https://doc.ubuntu-fr.org/apt)
  - MacOS : [Homebrew](https://brew.sh/)
  - Windows : [Chocolatey](https://docs.chocolatey.org/en-us/getting-started)

Dans un terminal ou un PowerShell, lancez l'outils correspondant à votre machine via les commandes ```update``` et ```upgrade``` qui vont respectivement mettre à jour leur base de paquets et mettre à jours les paquets installés.

Dans certains cas, des paquets sont déjà installés mais pas géré par le gestionnaire de paquets, pour forcer la réinstallation, tapez ```<brew|apt-get|choco> install git```.

### Créez un espace de travail

Choisissez un dossier racine pour vos projets; ```~/Workspace/IT-Akademy``` est conseillé.
Dans ce projet, créez les dossiers ```.git``` et ```.ssh```.

### Création de clés SSH

Git implémente le [protocole SSH](https://www.ssh.com/academy/ssh/openssh#ssh-key-management) pour sécuriser ses échanges interserveurs.
Une bonne pratique consiste à utiliser des clés SSH différentes en fonction des contextes afin d'éviter de multiplier les vulnérabilités en cas de fuite de données. Elle permettra également d'avoir des configurations différentes en fonction des projets sans risque de surcharges.

Dans un premier temps, créez un couple de clées privées et publiques ```it_akademy_rsa.pub``` et ```it_akademy_rsa```, protégée par un mot de passe et/ou une sécurisation biométrique.
Pour ce faire, utilisez l'outil [SSH-keygen](https://www.ssh.com/academy/ssh/keygen) ou équivalent sur votre plateforme.

### Paramétrage du compte Github

Créez un compte Github avec votre email ```@it-students.fr```.
Dans les paramètres de votre profil, cherchez l'entrée SSH & GPG keys. Ajoutez une nouvelle clé en copiant le contenu de la clé publique ```it_akademy_rsa.pub```.

Vous venez d'autoriser tout détenteur de ma clé ```it_akademy_rsa``` à déposer des fichier sur Github via votre compte sans mot de passe. Votre clé doit de fait rester secrète.

### Paramétrage de Git dans votre dossier de travail

Il est possible de créer des configurations globales, par projet ou dossier avec Git. Pour éditer des configurations globales, il est possible d'utiliser la commande ```git config --global``` et dans une copie de travail ```git config --local```.

Nous allons pour notre part éditer les configurations de Git directement via des fichiers.

Créez le fichier ```<votre_workspace_ici>/.git/config```, en remplaçant ```<votre_workspace_ici>``` par le chemin absolu de votre dossier, exemple : /Users/admin/Workspace/It-Akademy.

Éditez maintenant le fichier ```~/.gitconfig``` pour référencer votre fichier de configuration de votre workspace; ajoutez les lignes :
```
[includeIf "gitdir:<votre_workspace_ici>/"]
    path = <votre_workspace_ici>/.git/config
```

Dans votre fichier ```<votre_workspace_ici>/.git/config``` vous pouvez maintenant configurer Git pour avoir des comportements spécifiques à tous les projets dans ce dossier.

Commençons par vos nom-prénom-email :
```
[user]
    name = Chtulhu F'targn
    email = chtulhu.ftargn@it-students.fr
```

Les configurations fonctionnent par sections, ici nous avons modifié la section "user". C'est la composante avant le "." dans les commandes ```git config --global user.email....```.

Nous allons maintenant paramétrer Git pour qu'il utilise la clé SSH générée précédemment pour tous ses appels quand la commande est lancée depuis le dossier de travail.
Dans la section "core" du fichier de configuration, ajoutez l'entrée ```sshCommand``` pour que la commande ssh lancée par Git utilise votre clé privée avec l'option ```-i <votre_workspace_ici>/.ssh/it_akademy_rsa```.

Nous allons maintenant préparer notre premier dossier sous gestion de version.
Dans votre workspace, créez un dossier (`mkdir <nom_dossier>`) puis ouvrez le (`cd <nom_dossier>`).
Nous allons maintenant déclarer ce dossier sous gestion de version à Git via `git init -b main`. Git va créer un dossier `.git` dans lequel seront stockées toutes les informations nécessaires pour gérer les versions du dossier (on force la branche par défaut à `main` pour avoir une compatibilité facilité avec Github).

Pour vérifier que votre installation fonctionne correctement, vous pouvez taper la commande ```git config --list --show-origin```. Doivent figurer dans cette liste les entrées `user.name`, `user.email` et `core.sshCommand`.

### Travailler à partir d'un repository existant

Il est usuel de ne pas avoir accès en écriture à un dépôt Git, en particulier quand on travaille en Open Source. Pour proposer des modifications, Github implémente une mécanique de "fork", qui permet de faire une copie d'un dépôt vers votre espace personnel.

Créez un fork de ce dépôt.
Dans votre fork, récupérez son adresse SSH (sous le bouton "Code"), puis rendez vous dans votre dossier de travail, créé à l'étape précédente.

Pour lier votre dossier local à un dépôt distant, il reste à le déclarer en remote via la commande ```git remote add origin <adresse_ssh_du_fork>```. Notez que `origin` est un alias du dépôt, on utilise origin par convention.

Ajoutez un .gif humoristique sur Git au fichier ```README.md```.

Sauvegardez vos modifications puis créez un commit. Envoyez ensuite ce commit à votre dépôt. Si la configuration a été bien réalisée, votre commit sera visible dans l'interface de Github, et le .gif affiché dans la page principale.
Vérifiez également que le commit est à votre nom-prénom-email.


### Proposez une version au dépôt originel

Pour demander l'intégration d'une modification de code à un dépôt externe, Github implémente un système nommé "Pull Request" (PR). Lors de l'ouverture d'une PR, vous sélectionnez la branche de votre dépôt que vous voulez proposer, et la branche du dépôt principal dans laquelle vous voulez intégrer vos modifications.

Une fois créée, le gestionnaire pourra valider vos modification et les merge dans la branche voulue, ou vous demander des modifications via une "review". Modifiez le fichier ```README.md``` pour que le .gif soit en fait une animation humoristique avec un canard (vivant). Commit et push.

Votre PR a été automatiquement mise à jour.

Il peut par ailleurs arriver que d'autres modifications aient été merge avant les vôtres, rendant tout ou partie de votre branche obsolète. Pour la remettre à jour, il est nécessaire de la "rebase".

Commençons par récupérer la branche sur laquelle se baser (pour l'exercice, utilisez la branche ```rebase_me```).
Vous devez référencer le dépôt principal dans votre copie, et passer de fait en multi-remote. Utilisez la commande ```git remote add <url> <alias>```. Par convention, un dépôt en lecture seule est aliasé en "upstream".

Vous pouvez maintenant récupérer l'intégralité des branches du dépôt principal via ```git fetch <alias> -p```. Lancez maintenant le rebase de la branche ```rebase_me```, gérez les éventuels conflits (```git add / git rebase --continue```), puis poussez vos modifications.

Votre PR est désormais à jour et à nouveau compatible avec les dernières modifications.

### Ne pas laisser traîner ses artefacts

Certains OS et/ou IDE ajoutent des dossier et/ou fichiers cachés à vos projets. Certaines librairies ou frameworks génèrent également des dossiers et fichiers temporaires.
Enfin, les résidus d'exécution comme les logs, les caches ou les fichiers générés ne doivent pas être versionnés avec le reste du code : ils sont propres à votre machine.

Pour éviter de les propager, il suffit de les référencer dans un fichier ```.gitignore```. Il est possible de publier un fichier .gitignore pour la totalité de votre machine en remplissant la configuration globale "core.excludesfile".

Ajoutez le fichier ```add_this_gitignore``` à votre dossier ```<adresse_ssh_du_fork>/.git``` et référencez le dans la configuration de votre espace de travail.

### Pre-commits

Git permet également de référencer des scripts à exécuter avant et après chaque commit / push et autres opérations.

Ces scripts sont souvent utilisés pour valider des fichiers avant de les publier et permet de filtrer des erreurs avant leur propagation.

Déployez le précommit ```add_this_precommit``` dans le dossier ```<adresse_ssh_du_fork>/.git/hooks```. Veillez à le nommer ```pre-commit``` et à lui ajouter les droits en écriture.

Référencez maintenant le chemin du dossier contenant les hooks dans la configuration git de votre espace de travail, sous la clé "core.hooksPath".

Ouvrez le fichier ```test_hook.php``` et ajoutez un retour à la ligne en fin de fichier. Créez un commit avec cette modification. Si le hook est bien installé, le commit sera refusé.
