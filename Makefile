# Définition de la variable workspace_path
workspace_path ?= $(shell pwd | sed 's/ /\\ /g')

# Création du répertoire .ssh
.ssh:
	mkdir -p .ssh

# Création de la clé SSH
.ssh/it_akademy_rsa: .ssh
	ssh-keygen -q -f ./.ssh/it_akademy_rsa

# Vérification de l'installation de Git et création du répertoire .git
.git:
	@which git || brew install git
	mkdir .git

# Création du fichier de configuration Git
.git/config: .git
	@echo "[user]\n\tname = Sati Saakin\n\temail = s.saakian@it-akademy.fr" > .git/config
	@echo "[core]\n\tsshCommand = \"ssh -i $(workspace_path)/.ssh/it_akademy_rsa\"" >> .git/config
	@git config --list | grep $(workspace_path)/.git/config | wc -l | tr -d ' ' || (echo "[includeIf \"gitdir:$(workspace_path)/\"]\n\tpath=$(workspace_path)/.git/config" >> ~/.gitconfig)

# Affichage du contenu des fichiers
workspace: .ssh/it_akademy_rsa .git/config
	cat ./.ssh/it_akademy_rsa.pub
	cat .git/config

