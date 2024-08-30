include .env

OUTPUT_DIR = ~/Workspace/IT-Akademy/ItAK-DFS31C

all: $(USER_NAME)_file

$(USER_NAME)_file:
	@echo "$(USER_NAME)" > $(OUTPUT_DIR)/$(USER_NAME)_file.txt
	@echo "$(USER_EMAIL)" >> $(OUTPUT_DIR)/$(USER_NAME)_file.txt
	@cat $(OUTPUT_DIR)/$(USER_NAME)_file.txt

# Crée un fichier avec le nom et prénom de l'utilisateur
.PHONY: create_user_file

create_user_file:
	@touch $(USER_NAME).txt
	@echo "$(USER_NAME) $(USER_EMAIL)" > $(USER_NAME).txt

# Affiche le contenu du fichier
.PHONY: display_user_file

display_user_file:
	@cat $(USER_NAME).txt

# Génère le fichier .git/config
.PHONY: generate_git_config

generate_git_config:
	git config user.name "$(USER_NAME)"
	git config user.email "$(USER_EMAIL)"

# Crée le dossier ssh et la paire de clés
.PHONY: create_ssh_dir_and_keys

generate_ssh_key:
	@mkdir -p ~/Workspace/IT-Akademy/.ssh
	@ssh-keygen -t rsa -b 4096 -C "$(USER_EMAIL)" -f ~/Workspace/IT-Akademy/.ssh/it_akademy_rsa
