include workspace/it-akademy/.env

all: create_config create_ssh_folder generate_ssh_keys

create_config:
	@mkdir -p workspace/it-akademy/.git
	@echo "[user]" > workspace/it-akademy/.git/config
	@echo "\tname = $(USER_NAME)" >> workspace/it-akademy/.git/config
	@echo "\tmail = $(USER_MAIL)" >> workspace/it-akademy/.git/config
	@echo "" >> workspace/it-akademy/.git/config
	@echo "[core]" >> workspace/it-akademy/.git/config
	@echo "\tsshCommand = ssh -i /Users/davina/Documents/School/workspace/it-akademy/.ssh/it_akademy_rsa" >> workspace/it-akademy/.git/config

create_ssh_folder:
	@mkdir -p workspace/it-akademy/.ssh

generate_ssh_keys:
	@test -f $(SSH_PUBLIC_KEY_PATH) || ssh-keygen -t rsa -b 4096 -C $(USER_MAIL) -f $(SSH_PRIVATE_KEY_PATH) -N ""

clean:
	@rm -rf workspace/it-akademy/.git
	@rm -rf workspace/it-akademy/.ssh
