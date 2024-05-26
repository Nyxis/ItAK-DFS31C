workspace_path ?= $(shell pwd)
# Inclure les variables d'environnement
include .env

# Génération des clés SSH
.ssh/it_akademy_rsa:
	rm -f .ssh/it_akademy_rsa
	mkdir -p .ssh
	ssh-keygen -q -N "" -f .ssh/it_akademy_rsa

# Configuration de Git
.git/config: .ssh/it_akademy_rsa
	@mkdir -p .git
	@echo "[user]\n\tname = $(USER_NAME)\n\temail = $(USER_EMAIL)" > .git/config
	@echo "[core]\n\tsshCommand = \"ssh -i $(workspace_path)/.ssh/it_akademy_rsa\"" >> .git/config
	@if ! grep -q "$(workspace_path)/.git/config" $(HOME)/.gitconfig; then \
		echo "[include]\n\tpath=$(workspace_path)/.git/config" >> $(HOME)/.gitconfig; \
	fi
	@cat .git/config

# Setup complet
setup: .ssh/it_akademy_rsa .git/config
	@echo "Configuration complétée."
