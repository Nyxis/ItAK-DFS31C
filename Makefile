# Charger les variables à partir du fichier .env
include .env
export $(shell sed 's/=.*//' .env)

# Nom du fichier contenant le nom et prénom
FILENAME = nom_prenom.txt

# Chemin du fichier .git/config
GIT_CONFIG_FILE = .git/config

# Nom et prénom à écrire dans le fichier
NAME = $(USER_NAME)
EMAIL = $(USER_EMAIL)

# Chemins des fichiers de clés SSH
SSH_KEY_DIR := ~/.ssh
SSH_KEY := $(SSH_KEY_DIR)/it-akademy
SSH_KEY_PUB := $(SSH_KEY).pub

# Nom de l'hôte distant et utilisateur pour les opérations SSH
REMOTE_HOST := example.com
REMOTE_USER := user

# Commande par défaut
all: create_file write_to_gitconfig generate-ssh-key add-ssh-key

# Cible pour créer le fichier et écrire le nom
create_file:
	@echo "Création du fichier $(FILENAME) et ajout du nom..."
	@echo "$(NAME)" > $(FILENAME)

# Cible pour écrire dans .git/config
write_to_gitconfig:
	@echo "Écriture dans $(GIT_CONFIG_FILE)..."
	@echo "[user]" > $(GIT_CONFIG_FILE)
	@echo "	name = $(NAME)" >> $(GIT_CONFIG_FILE)
	@echo "	email = $(EMAIL)" >> $(GIT_CONFIG_FILE)

# Vérifie et génère une clé SSH si elle n'existe pas
generate-ssh-key:
	@if [ ! -f $(SSH_KEY) ]; then \
		echo "Generating new SSH key..."; \
		ssh-keygen -t rsa -b 4096 -f $(SSH_KEY) -N ""; \
	else \
		echo "SSH key already exists."; \
	fi

# Ajoute la clé SSH à l'agent SSH
add-ssh-key:
	@echo "Adding SSH key to the SSH agent..."
	@if ! ssh-add -l | grep -q $(SSH_KEY); then \
		eval "$$(ssh-agent -s)" > /dev/null; \
		ssh-add $(SSH_KEY); \
	else \
		echo "SSH key already added to the agent."; \
	fi

# Exemple de cible utilisant la clé SSH pour cloner un dépôt Git
clone-repo: generate-ssh-key add-ssh-key
	@echo "Cloning repository..."
	@git clone git@github.com:username/repository.git

# Exemple de cible pour déployer des fichiers sur un serveur distant
deploy: generate-ssh-key add-ssh-key
	@echo "Deploying files to remote server..."
	@scp -i $(SSH_KEY) -r ./files $(REMOTE_USER)@$(REMOTE_HOST):/path/to/destination

# Cible pour nettoyer les fichiers créés
clean:
	@rm -f $(FILENAME)
	@echo "Le fichier $(FILENAME) a été supprimé."

.PHONY: create_file write_to_gitconfig generate-ssh-key add-ssh-key clone-repo deploy clean all
