# Include environment variables
include .env

# Check if a command exists
command_exists = $(shell command -v $(1) >/dev/null 2>&1 && echo "yes" || echo "no")

# Cible pour créer le fichier avec le nom et le prénom
create:
	@echo "${USER_NAME}" > myname.txt

# Cible pour afficher le contenu du fichier
display:
	@cat myname.txt

# Cible pour configurer Git
gitconfig:
	@git config --global user.name "${USER_NAME}"
	@git config --global user.email "${USER_EMAIL}"
	@git config --global filter.lfs.clean "git-lfs clean -- %f"
	@git config --global filter.lfs.smudge "git-lfs smudge -- %f"
	@git config --global filter.lfs.process "git-lfs filter-process"
	@git config --global filter.lfs.required true
	@git config --global core.sshCommand "ssh -i ~/.ssh/it_akademy_rsa"
	@git config --global core.editor "code --wait"
	@git config --global core.autocrlf input
	@git config --global includeIf.gitdir:~/Workspace/IT-Akademy/.path "~/Workspace/IT-Akademy/.git/config"
	@git config --global diff.tool vscode
	@git config --global difftool.vscode.cmd "code --wait --diff $$LOCAL $$REMOTE"

# Cible pour configurer SSH
sshconfig:
	@echo "Creating SSH config..."
	@mkdir -p ~/.ssh
	@touch ~/.ssh/config
	@echo "Host github.com" >> ~/.ssh/config
	@echo "  IdentityFile ~/.ssh/it_akademy_rsa" >> ~/.ssh/config
	@chmod 600 ~/.ssh/config

# Cible pour installer des outils et des plugins
install_tools:
	@echo "Installing tools..."
	@if [ "$(call command_exists,git-lfs)" = "no" ]; then \
		if [ -x "$(command -v apt-get)" ]; then sudo apt-get install -y git-lfs; fi; \
		if [ -x "$(command -v brew)" ]; then brew install git-lfs; fi; \
	fi
	@if [ "$(call command_exists,code)" = "no" ]; then \
		if [ -x "$(command -v apt-get)" ]; then sudo apt-get install -y code; fi; \
		if [ -x "$(command -v brew)" ]; then brew install --cask visual-studio-code; fi; \
	fi
	@if [ "$(call command_exists,fish)" = "no" ]; then \
		if [ -x "$(command -v apt-get)" ]; then sudo apt-get install -y fish; fi; \
		if [ -x "$(command -v brew)" ]; then brew install fish; fi; \
	fi
	@git lfs install

# Cible pour configurer le shell (fish) et installer des plugins
shell_config:
	@echo "Configuring shell and installing plugins..."
	@if [ ! -d ~/.local/share/omf ]; then \
		curl -L https://get.oh-my.fish | fish; \
	fi
	@if [ ! -x "$(command -v fisher)" ]; then \
		curl -sL https://git.io/fisher | source && fisher install jorgebucaran/fisher; \
	fi
	@fish -c "fisher install <plugin_name_1>"
	@fish -c "fisher install <plugin_name_2>"

# Cible pour installer les extensions de VSCode
vscode_extensions:
	@echo "Installing VSCode extensions..."
	@code --install-extension ms-python.python || true
	@code --install-extension esbenp.prettier-vscode || true
	# Add other extensions as needed

# Cible par défaut pour exécuter les cibles ci-dessus
all: create display gitconfig sshconfig install_tools shell_config vscode_extensions
