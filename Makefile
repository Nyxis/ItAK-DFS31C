# Makefile for initializing the work environment

WORKSPACE=$(shell pwd)
SSH_DIR=$(WORKSPACE)/.ssh
GIT_DIR=$(WORKSPACE)/.git
PRIVATE_KEY=$(SSH_DIR)/id_rsa
ENV_FILE=$(WORKSPACE)/.env

.PHONY: all init_ssh init_git generate_ssh_key configure_git

all: init_ssh init_git generate_ssh_key configure_git

# Create the .ssh and .git directories if they don't exist
init_ssh:
	mkdir -p $(SSH_DIR)

init_git:
	mkdir -p $(GIT_DIR)

# Generate SSH keys
generate_ssh_key: init_ssh
	ssh-keygen -t rsa -b 4096 -f $(PRIVATE_KEY) -N ""

# Configure the git config file
configure_git: init_git
	@set -a; \
	. $(ENV_FILE); \
	ABS_PRIVATE_KEY=$$(cd $(SSH_DIR) && pwd)/id_rsa; \
	echo "[user]" > $(GIT_DIR)/config; \
	echo "    name = $$USER_NAME" >> $(GIT_DIR)/config; \
	echo "    email = $$USER_EMAIL" >> $(GIT_DIR)/config; \
	echo "[core]" >> $(GIT_DIR)/config; \
	echo "    sshCommand = \"ssh -i $${ABS_PRIVATE_KEY}\"" >> $(GIT_DIR)/config
