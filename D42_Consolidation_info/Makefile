include .env
export $(shell sed 's/=.*//' .env)

WORKSPACE_PATH := $(shell mkdir -p ~/workspace/IT-Akademy && cd ~/workspace/IT-Akademy && pwd)

GIT_CONFIG_FILE = $(WORKSPACE_PATH)/.git/config

GITMAINCONF = $(HOME)/.gitconfig

NAME = $(USER_NAME)
EMAIL = $(USER_EMAIL)

install: create_dirs ssh_config write_to_gitconfig force_git_config
	@echo "Configuration complète!"

create_dirs:
	@mkdir -p $(WORKSPACE_PATH)/.git
	@mkdir -p $(WORKSPACE_PATH)/.ssh

write_to_gitconfig: create_dirs
	@echo "Écriture dans $(GIT_CONFIG_FILE)..."
	@echo "[user]" >> $(GIT_CONFIG_FILE)
	@echo "name = $(NAME)" >> $(GIT_CONFIG_FILE)
	@echo "email = $(EMAIL)" >> $(GIT_CONFIG_FILE)
	@echo "[core]" >> $(GIT_CONFIG_FILE)
	@echo "sshCommand = \"ssh -i $(WORKSPACE_PATH)/.ssh/it_akademy_rsa\"" >> $(GIT_CONFIG_FILE)
	@if [ $$? -ne 0 ]; then \
		echo "!! Configuration incomplète du git/config!!" ; \
	fi

ssh_config: create_dirs
	@if [ \! -s $(WORKSPACE_PATH)/.ssh/it_akademy_rsa ]; then \
		echo "Création d'une nouvelle clé SSH..."; \
		ssh-keygen -t rsa -b 4096 -C "$(EMAIL)" -N "" -f $(WORKSPACE_PATH)/.ssh/it_akademy_rsa; \
	fi
	@if [ $$? -ne 0 ]; then \
		echo "!! Configuration incomplète des clés ssh!!" ; \
		exit 1; \
	fi

force_git_config:
	@echo "Modifying .gitconfig file..."
	@touch $(GITMAINCONF)
	@grep -qxF '[includeif "gitdir:$(WORKSPACE_PATH)/"]' $(GITMAINCONF) || echo '[includeif "gitdir:$(WORKSPACE_PATH)/"]\n\tpath = $(WORKSPACE_PATH)/.git/config' >> $(GITMAINCONF)
