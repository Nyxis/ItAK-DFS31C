# Livrer ses exercices

1/ Effectuez un fork de ce dépôt en utilisant votre compte @it-students :
- Fork ⏷
- Create a new fork
Vous disposez maintenant de votre propre dépôt dans lequel vous pouvez déposer tout votre code.

2/ Clonez votre dépôt sur votre machine. Le protocole SSH est recommandé.
- <> Code ⏷
- SSH
- Copiez l'adresse git@github.com:xxxxxxxx/ItAK-DFSyyyyyy.git)

```shell
git clone -b main <url copiée>
cd <dossier créé>
git remote add upstream git@github.com:Nyxis/ItAK-DFS28C.git
```

3/ Effectuez les exercices

4/ Créez un commit avec vos modifications, puis envoyez le à votre dépôt.
```shell
git add .
git commit -m "<message de commit>"
git pull --rebase upstream main
# résolvez les éventuels conflits
git push origin main --force
```

5/ Dans votre dépôt, créez une Pull Request à partir de la branche que vous venez de déposer
- Pull Requests
- New Pull Request
- "compare accross forks"
- base repository : `Nyxis/ItAK-DFS31C` / base : `main` / head repository : `<votre fork>` / compare : `main`
- Create pull request
- Title : `Nom Prenom - Titre exercice`

