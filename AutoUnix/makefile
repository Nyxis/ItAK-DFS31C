.PHONY: install create-dirs generate-ssh-key configure-git install-software install-brew install-git install-fish install-fisher install-vscode

include .env

WORKSPACE_PATH := $(shell cd ~/workspace/IT-Akademy && pwd)

install: create-dirs generate-ssh-key configure-git install-software

create-dirs:
	@echo "Creating .ssh and .git directories..."
	mkdir -p $(WORKSPACE_PATH)/.ssh
	mkdir -p $(WORKSPACE_PATH)/.git
	@echo ".ssh and .git directories created."

generate-ssh-key:
	@echo "Generating SSH key..."
	ssh-keygen -q -f $(WORKSPACE_PATH)/.ssh/it_akademy_rsa -N ""
	@echo "SSH key generated."
	@echo "Copy the following SSH key and add it to your GitHub account ($(USER_NAME)):"
	@cat $(WORKSPACE_PATH)/.ssh/it_akademy_rsa.pub
	@echo "Instructions: https://github.com/settings/keys"

configure-git: configure-git-local configure-git-global

configure-git-local:
	@echo "Configuring local Git..."
	echo "[user]\n\tname = $(USER_NAME)\n\temail = $(USER_EMAIL)\n[core]\n\tsshCommand = \"ssh -i $(WORKSPACE_PATH)/.ssh/it_akademy_rsa\"" > $(WORKSPACE_PATH)/.git/config
	@echo "Local Git configured."

configure-git-global:
	@echo "Configuring global Git to include workspace-specific config..."
	grep -qxF '[includeif "gitdir:$(WORKSPACE_PATH)"]' ~/.gitconfig || echo '[includeif "gitdir:$(WORKSPACE_PATH)/"]\n\tpath = $(WORKSPACE_PATH)/.git/config' >> ~/.gitconfig
	@echo "Global Git configured to include workspace-specific config."

install-software: install-brew install-git install-fish install-fisher install-vscode

install-brew:
	@echo "Checking for Homebrew..."
	which brew || /bin/bash -c "$$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
	@echo "Homebrew installed."

install-git:
	@echo "Checking for Git..."
	which git || brew install git
	@echo "Git installed."

install-fish:
	@echo "Installing Fish Shell..."
	brew install fish
	@echo "Fish Shell installed."

install-fisher:
	@echo "Installing Fisher..."
	curl -sL https://git.io/fisher | source && fisher install jorgebucaran/fisher
	fisher install jorgebucaran/hydro
	fisher install oh-my-fish/plugin-bang-bang
	@echo "Fisher and plugins installed."

install-vscode:
	@echo "Installing Visual Studio Code..."
	brew install --cask visual-studio-code
	@echo "Visual Studio Code installed."
