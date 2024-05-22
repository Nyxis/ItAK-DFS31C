# Include environment variables
include .env

workspace_path := $(shell pwd | sed 's/ /\\ /g')

# Cible pour créer le fichier avec le nom et le prénom
create:
	@echo "${USER_NAME}" > myname.txt

# Cible pour afficher le contenu du fichier
display:
	@cat myname.txt

# Cible pour configurer Git
gitconfig:
	@git config --global user.name || git config --global user.name "${USER_NAME}"
	@git config --global user.email || git config --global user.email "${USER_EMAIL}"
	@git config --global filter.lfs.clean || git config --global filter.lfs.clean "git-lfs clean -- %f"
	@git config --global filter.lfs.smudge || git config --global filter.lfs.smudge "git-lfs smudge -- %f"
	@git config --global filter.lfs.process || git config --global filter.lfs.process "git-lfs filter-process"
	@git config --global filter.lfs.required || git config --global filter.lfs.required true
	@git config --global core.sshCommand || git config --global core.sshCommand "ssh -i $(workspace_path)/.ssh/it_akademy_rsa"
	@git config --global core.editor || git config --global core.editor "code --wait"
	@git config --global core.autocrlf || git config --global core.autocrlf input
	@git config --global includeIf.gitdir:$(workspace_path)/.path || git config --global includeIf.gitdir:$(workspace_path)/.path "$(workspace_path)/.git/config"
	@git config --global diff.tool || git config --global diff.tool vscode
	@git config --global difftool.vscode.cmd || git config --global difftool.vscode.cmd "code --wait --diff $$LOCAL $$REMOTE"

# Cible pour configurer SSH
.ssh:
	@echo "Creating SSH config..."
	@mkdir -p .ssh

.ssh/it_akademy_rsa: .ssh
	@ssh-keygen -q -f ./.ssh/it_akademy_rsa

# Cible pour installer des outils et des plugins
install_tools:
	@echo "Installing tools..."
	@if [ -x "$(command -v apt-get)" ]; then sudo apt-get install -y git-lfs code fish; fi
	@if [ -x "$(command -v brew)" ]; then brew install git-lfs fish; brew install --cask visual-studio-code; fi
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

# Configuration complète de l'espace de travail
workspace: .ssh/it_akademy_rsa .git/config
	@cat ./.ssh/it_akademy_rsa.pub
	@cat .git/config

# Cible par défaut pour exécuter les cibles ci-dessus
all: create display gitconfig sshconfig install_tools shell_config vscode_extensions workspace
