# Makefile pour automatiser la création et l'affichage de myname.txt

include .env

# Cible pour créer le fichier avec le nom et le prénom
create:
		echo "${USER_NAME}" > myname.txt

# Cible pour afficher le contenu du fichier
display:
		cat myname.txt

# Cible pour écrire dans le fichier .git/config
gitconfig:
		echo "[user]" > .git/config
		echo "  name = ${USER_NAME}" >> .git/config
		echo "  email = ${USER_EMAIL}" >> .git/config
		echo "[core]" >> .git/config
		echo "  sshCommand = \"ssh -i ~/.ssh/it_akademy_rsa\"" >> .git/config

# Cible pour configurer SSH
sshconfig:
		mkdir -p ~/.ssh
		touch ~/.ssh/config
		echo "Host github.com" >> ~/.ssh/config
		echo "  IdentityFile ~/.ssh/it_akademy_rsa" >> ~/.ssh/config
		chmod 600 ~/.ssh/config

# Cible par défaut pour exécuter les cibles ci-dessus
all: create display gitconfig sshconfig
