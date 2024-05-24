include .env
export

SSH_KEY_FILE := id_rsa

# Cibles
.PHONY: all setup clean create_git_dir create_config_file create_ssh_key add_ssh_key

all: setup

setup: create_git_dir create_config_file add_ssh_key
	@echo "Configuration terminée."

.ssh:
	@echo "Création du répertoire .ssh..."
	@mkdir -p .ssh

.ssh/$(SSH_KEY_FILE): .ssh
	ssh-keygen -q -f ./.ssh/id_rsa

create_git_dir:
	@echo "Création du répertoire .git..."
	@if [ ! -d ".git" ]; then \
		mkdir -p .git; \
	fi

create_config_file: create_git_dir
	@echo "Création du fichier .git/config..."
	@if [ -d ".git" ]; then \
		echo "[user]" > .git/config; \
		echo "name = $(USER_NAME)" >> .git/config; \
		echo "email = $(USER_EMAIL)" >> .git/config; \
		echo "[core]" >> .git/config; \
		echo "	sshCommand = ssh -i /Users/admin/Desktop/it/.ssh/id_rsa" >> .git/config; \
	fi

add_ssh_key: .ssh/$(SSH_KEY_FILE)
	@echo "Ajout de la clé SSH à l'agent..."
	@if ! ssh-add -l | grep -q -F $(SSH_KEY_FILE); then \
		eval "$$(ssh-agent -s)"; \
		ssh-add .ssh/$(SSH_KEY_FILE); \
	else \
		echo "La clé SSH $(SSH_KEY_FILE) est déjà ajoutée à l'agent."; \
	fi
