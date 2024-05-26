include .env


ssh:
	mkdir ssh

git:
	mkdir git

generate_ssh_keys: ssh
	ssh-keygen -q -f $(PWD)/ssh/it_akademy_rsa

git_config: git generate_ssh_keys
	touch git/config 
	echo "[user]" >> git/config
	echo '\tname = ${USER_NAME}' >> git/config
	echo '\temail = ${USER_EMAIL}' >> git/config
	echo "[core]" >> git/config
	echo '\tsshCommand = "ssh -i $(PWD)/ssh/it_akademy_rsa"' >> git/config
	grep -q "gitdir:$(pwd)" ~/.gitconfig || echo '[includeIf "gitdir:$(PWD)/"]\n\tpath = $(PWD)/git/config' >> ~/.gitconfig 


install: git_config
	@echo 'install'


rm:
	rm -rf ssh git