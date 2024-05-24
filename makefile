# Makefile

# Charger les variables d'environnement
include .env

# Variables
GIT_DIR = .git
SSH_DIR = .ssh
CONFIG_FILE = config
NAME_FILE = name.txt
SSH_KEY_FILE = id_rsa
SSH_KEY_COMMENT = "m.slyemi@it-students.fr"

# Cibles
all: setup

setup: create_git_dir create_ssh_dir create_name_file create_config_file create_ssh_key add_ssh_key

create_git_dir:
	@echo "Création du répertoire $(GIT_DIR)..."
	@mkdir -p $(GIT_DIR)

create_ssh_dir:
	@echo "Création du répertoire $(SSH_DIR)..."
	@mkdir -p $(SSH_DIR)

create_name_file:
	@echo "Création du fichier $(NAME_FILE) avec votre nom et prénom..."
	@echo "$(USER_NAME)" > $(NAME_FILE)

create_config_file: create_git_dir create_name_file
	@echo "Création du fichier $(GIT_DIR)/$(CONFIG_FILE)..."
	@cp $(NAME_FILE) $(GIT_DIR)/$(CONFIG_FILE)
	@echo "Nom: $(USER_NAME)" >> $(GIT_DIR)/$(CONFIG_FILE)
	@echo "Email: $(USER_EMAIL)" >> $(GIT_DIR)/$(CONFIG_FILE)
	@echo "Configuration terminée."

create_ssh_key: create_ssh_dir
	@echo "Création de la paire de clés SSH..."
	@if [ ! -f $(SSH_DIR)/$(SSH_KEY_FILE) ]; then \
		read -sp 'Entrez la passphrase pour la clé SSH : ' passphrase && echo; \
		ssh-keygen -t rsa -b 4096 -C "$(SSH_KEY_COMMENT)" -f $(SSH_DIR)/$(SSH_KEY_FILE) -N "$$passphrase"; \
	else \
		echo "La clé SSH existe déjà."; \
	fi

add_ssh_key: create_ssh_key
	@echo "Ajout de la clé SSH à l'agent..."
	@eval "$$(ssh-agent -s)"
	@ssh-add $(SSH_DIR)/$(SSH_KEY_FILE)

clean:
	@echo "Nettoyage des fichiers générés..."
	@rm -rf $(GIT_DIR) $(NAME_FILE) $(SSH_DIR)
	@echo "Nettoyage terminé."
