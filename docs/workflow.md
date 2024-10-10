# Livrer son travail

1/ Effectuez un fork de ce dépôt en utilisant votre compte @it-students :
- Fork ⏷
- Create a new fork
Vous disposez maintenant de votre propre dépôt dans lequel vous pouvez déposer tout votre code.

2/ Clonez votre dépôt sur votre machine via SSH.
- <> Code ⏷
- SSH
- Copiez l'adresse git@github.com:xxxxxxxx/ItAK-DFSyyyyyy.git)

```shell
git clone -b main <url copiée>
cd <dossier créé>
git remote add upstream git@github.com:Nyxis/ItAK-DFS<votre numéro de session>.git
```

3/ Effectuez les exercices du module dans une branche créée à partir du main du dépôt principal
```shell
# création de la branche
git branch module_Dxx upstream/main
git checkout module_Dxx

# récupération de la dernière version des exercices
git checkout main
git pull --rebase upstream main
    # résolvez les éventuels conflits
    git add <fichiers de conflits résolus>
    git rebase --continue
git push origin main --force
git checkout module_Dxx
git rebase main
```

4/ Créez un commit avec vos modifications, puis envoyez le à votre dépôt.
```shell
git add <vos fichiers modifiés>
git commit -m "<message de commit>"
git push origin module_Dxx --force  # --force est nécessaire si un rebase a été effectué à l'étape 3
```

5/ Dans votre dépôt, créez une Pull Request à partir de la branche que vous venez de déposer
- Pull Requests
- New Pull Request
- "compare accross forks"
- Base repository : `Nyxis/ItAK-DFS<votre numéro de session>` / base : `main` / head repository : `<votre fork>` / compare : `main`
- Create pull request
- Title : `Nom Prenom - Code Module`

