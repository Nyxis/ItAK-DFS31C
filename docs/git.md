# Bonnes pratiques Git

Git étant un sytème très ouvert par nature, une mésutilisation peut rapidement conduire à des situations inextricables où il devient très lourd au point de ne plus pouvoir commit, voire à des pertes de travail.
Il est également possible d'avoir rapidement des failles de sécurité dans la base de code.

Afin d'éviter ces situations, il convient de respecter certaines bonnes pratiques.

## Versionner uniquement les fichiers sources

Un `.gitignore` doit être créé dans tous les projets afin d'exclure certains fichiers de la gestion de version. Quatre grands types d'exclusions sont à considérer :
 - Les fichiers propres à votre système et votre installation (Thumbs, .DS_Store, /idea, configuration de développement...)
 - Les fichiers compilés (le css généré par Sass, le js généré depuis TypeScript...)
 - Les artefacts d'exécution de votre programme (fichiers de cache, de logs...)
 - Les librairies externes (vendor, node_modules...)

Il appartient aux développeurs de compléter et maintenir le fichier `.gitignore` afin de ne jamais introduire des fichiers indésirables dans un dépôt.

Il est également possible de définir un `.gitignore` global pour toute votre machine :
```ini
# ~/.gitconfig
[core]
    excludesfile = /<chemin>/<vers>/.gitignore
```

## Utiliser des precommit

Utiliser des scripts pre-commits permet de vérifier que le code envoyé ne comporte pas d'erreurs mettant en difficulté toute autre personne en position d'exécuter votre code.

Par exemple, il est possible de lancer la commande `php -l` sur tous les fichiers Php présents dans le commit, à la recherche de parse errors.

Pour installer un precommit dans une copie de travail, il suffit de créer un fichier `.git/hooks/pre-commit` qui contient les instructions.

Exemple de precommit :
```shell
#!/bin/bash

php_files=$(git diff --cached --name-only --diff-filter=ACM | grep -E '\.php$')
if [[ "$php_files" ]]; then
  for file in $php_files; do
    php -l "$file"
    if [[ $? -ne 0 ]]; then
      fail_commit "Erreur de syntaxe PHP dans le fichier: $file"
    fi
  done
fi
```

## Autres configurations utiles

Ces configuration activent des plugins très utiles

```ini
[core]
    editor = code # pour vscode
    symlinks = true
[format]
    pretty = oneline
[rebase]
    autoStash = true
    autoSquash = true
[rerere]
    autoupdate = true
    enabled = true
[color]
    ui = true
```

