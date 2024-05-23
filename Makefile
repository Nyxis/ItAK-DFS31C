include .env

workspace_path ?= $(shell pwd)

monprenom:
	echo "$(USER_NAME)" > monprenom.txt
	cat monprenom.txt
.git: monprenom
		mkdir -p .git

.gitconfig: .git
	@echo -e "[user]\n\tname = $(USER_NAME) \n\temail = $(USER_EMAIL)" >> .git/config
	@echo -e "[core]\n\tsshCommand = \"ssh -i" $(shell pwd)/.ssh/it_akademy_rsa\" >> .git/config
	cat .git/config

.ssh: .gitconfig
		mkdir .ssh

accesgitit: .ssh

		ssh-keygen -q -f ./.ssh/it_akademy_rsa
		cat ./.ssh/it_akademy_rsa.pub

