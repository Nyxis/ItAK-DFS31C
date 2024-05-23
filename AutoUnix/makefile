
.PHONY: setup ssh-setup git-config install-software

# Include environment variables
include .env

setup:
    @echo "Creating base directory structure..."
    mkdir -p ~/workspace/IT-Akademy/ItAK-DFS31C
    @echo "Directory structure created."

# Cible pour créer le fichier avec le nom et le prénom
create:
	@echo "${USER_NAME}" > myname.txt

# Cible pour afficher le contenu du fichier
display:
	@cat myname.txt

ssh-setup:
    @echo "Generating SSH key..."
    ssh-keygen -t rsa -b 4096 -C "$(GIT_USER_EMAIL)" -f ~/.ssh/id_rsa -N ""
    @echo "SSH key generated."

    @echo "Adding SSH key to the ssh-agent..."
    eval "$(ssh-agent -s)"
    ssh-add ~/.ssh/id_rsa
    @echo "SSH key added to ssh-agent."

    @echo "Copy the following SSH key and add it to your GitHub account ($(GIT_USER_NAME)):"
    @cat ~/.ssh/id_rsa.pub
    @echo "Instructions: https://github.com/settings/keys"

git-config:
    @echo "Configuring Git..."
    git config --global user.name "$(GIT_USER_NAME)"
    git config --global user.email "$(GIT_USER_EMAIL)"
    git config --global core.editor "code --wait"
    git config --global diff.tool "vscode"
    git config --global difftool.vscode.cmd "code --wait --diff $$LOCAL $$REMOTE"
    git config --global core.autocrlf input
    @echo "Git configured."

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

    
