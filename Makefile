include: .env
workpath ?= $(shell pwd)

Workspace
	@mkdir Workspace

.ssh
	@mkdir .ssh

.it_akademy_rsa
	@ssh-keygen -q -f $workpath/.ssh/it_akademy_rsa
	
.git
	@git -v || brew install git; git init
	@mkdir .git

.git/config
	@echo "[user]\n\tname = $USER_NAME \n\temail = $USER_EMAIL \n\t[core]sshCommand = "ssh -i $workpath/.ssh/it_akademy_rsa"" >> .git/config \n\tmv /Users/admin/ItAK-DFS31C/add_this_gitigore ~/Users/admin/.gitignore >> .git/config
	
.gitconfig
	@grep 'IncludeIf' ~/.gitconfig || @echo "[includeIf "gitdir:$workpath/Workspace"] \n\tpath = $workpath/.git/config" >> .gitconfig

