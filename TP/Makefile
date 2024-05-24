include .env

all: create_config create_ssh_folder generate_ssh_keys

create_config:
	@mkdir -p .git
	@echo "[user]" > .git/config
	@echo "\tname = $(name)" >> .git/config
	@echo "\tmail = $(mail)" >> .git/config
	@echo "" >> .git/config
	@echo "[core]" >> .git/config
	@echo "\tsshCommand = ssh -i /home/rayane/workspace/it-akademy/.ssh/rayane_rsa" >> .git/config

create_ssh_folder:
	@mkdir -p .ssh

generate_ssh_keys:
	@test -f $(SSH_PUBLIC_KEY_PATH) || ssh-keygen -t rsa -b 4096 -C $(mail) -f $(SSH_PRIVATE_KEY_PATH) -N ""

clean:
	@rm -rf .git
	@rm -rf .ssh
