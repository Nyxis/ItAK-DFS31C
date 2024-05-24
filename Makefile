include .env

SSH_KEY_PATH=$(shell pwd)/.ssh/it_akademy_rsa

.PHONY: install

install: .ssh/it_akademy_rsa .git/config config-global
	@echo "Canardisation effectué !"

.ssh:
	mkdir .ssh

.ssh/it_akademy_rsa: .ssh
	ssh-keygen -q -f $(SSH_KEY_PATH) -N ""

.git:
	mkdir .git

.git/config: .git
	echo "[user]\n\tname = $(USER_NAME)\n\temail = $(USER_EMAIL)\n[core]\n\tsshCommand = \"ssh -i $(SSH_KEY_PATH)\"" > .git/config


config-global:
	@grep -qxF '[includeif "gitdir:$(shell pwd)"]' ~/.gitconfig || echo '[includeif "gitdir:$(shell pwd)"]\n\tpath=$(shell pwd)/.git/config' >> ~/.gitconfig
