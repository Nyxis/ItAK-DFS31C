include .env

workspace_path ?= $(shell pwd)

monprenom:
	echo "$(USER_NAME)" > monprenom.txt
	cat monprenom.txt
.git: monprenom
		@git -v || brew install git
		mkdir -p .git	

.gitconfig: .git
	@echo "[user]\n\tname = $(USER_NAME) \n\temail = $(USER_EMAIL)" >> .git/config
	@echo "[core]\n\tsshCommand = \"ssh -i" $(shell pwd)/.ssh/it_akademy_rsa\" >> .git/config
	@(git config --list | grep $(workspace_path)/.git/config) || (echo "[includeif \"gitdir:$(workspace_path)/\"]\n\tpath=$(shell pwd)/.git/config" >> $(HOME)/.gitconfig)
	cat .git/config

.ssh: .gitconfig
		mkdir .ssh

accesgitit: .ssh

		ssh-keygen -q -f ./.ssh/it_akademy_rsa
		cat ./.ssh/it_akademy_rsa.pub

