# Include environment variables
include .env

workspace_path := $(shell pwd | sed 's/ /\\ /g')

# Cible pour créer le fichier avec le nom et le prénom
create:
	@echo "${USER_NAME}" > myname.txt

# Cible pour afficher le contenu du fichier
display:
	@cat myname.txt

