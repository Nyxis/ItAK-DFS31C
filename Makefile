include .env

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
    mkdir -p .git

# Création du fichier de configuration Git
.git/config: .git
    @echo "[user]\n\tname = Sati Saakin\n\temail = s.saakian@it-akademy.fr" > .git/config
    @echo "[core]\n\tsshCommand = \"ssh -i $(shell pwd)/.ssh/it_akademy_rsa\"" >> .git/config
    @(git config --list | grep $(workspace_path)/.git/config) || (echo "[includeIf \"gitdir:$(workspace_path)/\"]\n\tpath=$(workspace_path)/.git/config" >> $(HOME)/.gitconfig)

# Affichage du contenu des fichiers et clonage du dépôt
workspace: .ssh/it_akademy_rsa .git/config
    @echo "Adresse SSH du dépôt : "; \
    read remote_ssh_url; \
    folder_name=`echo $$remote_ssh_url | sed 's#.*/\([^/]*\)\.git#\1#'`; \
    mkdir $$folder_name; \
    cd $$folder_name; \
    git init -b main; \
    git remote add origin $$remote_ssh_url; \
    git fetch; \
    git checkout -t origin/main;

