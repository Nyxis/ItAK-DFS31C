# Charger les variables à partir du fichier .env
include .env

# Chemin absolu du workspace
WORKSPACE_DIR := $(shell pwd)

# Chemin absolu du dossier .ssh dans le workspace
SSH_DIR := $(WORKSPACE_DIR)/.ssh

# Chemin absolu du dossier .git dans le workspace
GIT_DIR := $(WORKSPACE_DIR)/.git

# Chemin absolu de la clé SSH dans le dossier .ssh
SSH_KEY := $(SSH_DIR)/it-akademy

# Chemin absolu du fichier .git/config
GIT_CONFIG_FILE := $(GIT_DIR)/config

# Nom et email de l'utilisateur Git
USER_NAME := $(shell echo $(USER_NAME))
USER_EMAIL := $(shell echo $(USER_EMAIL))

# Commande par défaut
install: create_ssh_dir create_git_dir generate_ssh_key generate_git_config

# Création du dossier .ssh
create_ssh_dir:
	mkdir -p $(SSH_DIR)

# Création du dossier .git
create_git_dir:
	mkdir -p $(GIT_DIR)

# Générer une paire de clés SSH
generate_ssh_key:
	ssh-keygen -q -f $(SSH_KEY) -N ""

# Générer le fichier .git/config
generate_git_config:
	@echo "[user]" > $(GIT_CONFIG_FILE)
	@echo "\tname = $(USER_NAME)" >> $(GIT_CONFIG_FILE)
	@echo "\temail = $(USER_EMAIL)" >> $(GIT_CONFIG_FILE)
	@echo "[core]" >> $(GIT_CONFIG_FILE)
	@echo "\tsshCommand = \"ssh -i $(SSH_KEY)\"" >> $(GIT_CONFIG_FILE)

	# Ajout de la configuration spécifique au workspace dans ~/.gitconfig si nécessaire
	@grep -qxF '[includeIf "gitdir:$(WORKSPACE_DIR)"]' ~/.gitconfig || echo '\n[includeIf "gitdir:$(WORKSPACE_DIR)"]\n\tpath=$(GIT_DIR)/config' >> ~/.gitconfig

# Nettoyage du workspace
clean:
	rm -rf $(SSH_DIR)
	rm -rf $(GIT_DIR)
	rm -f .env

.PHONY: install create_ssh_dir create_git_dir generate_ssh_key generate_git_config clean
