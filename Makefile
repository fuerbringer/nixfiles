NOW = $(shell date -u +"%Y-%m-%dT%H:%M:%SZ")
NIXOS_CONF := /etc/nixos/
NIXOS_CONF_BACKUP := /tmp/
NIXOS_CONF_BACKUP_EXT := .nixos.tar.gz
NIXOS_CONF_BACKUP_FILE := $(NIXOS_CONF_BACKUP)$(NOW)$(NIXOS_CONF_BACKUP_EXT)

deploy:
	test -n "$(machine)"	# $$machine must be set (folder name with nix configs)
	echo "# Replaced by $(machine) configuration" | sudo tee --append $(NIXOS_CONF)meta > /dev/null
	sudo tar czf $(NIXOS_CONF_BACKUP_FILE) $(NIXOS_CONF)*
	sudo chmod 0600 $(NIXOS_CONF_BACKUP_FILE)
	sudo cp -r ./$(machine)/* $(NIXOS_CONF)

purge:
	test -n "$(machine)"	# $$machine must be set (folder name with nix configs)
	echo "# Purged by $(machine) configuration" | sudo tee --append $(NIXOS_CONF)meta > /dev/null
	sudo tar czf $(NIXOS_CONF_BACKUP_FILE) $(NIXOS_CONF)*
	sudo chmod 0600 $(NIXOS_CONF_BACKUP_FILE)
	sudo rm -r $(NIXOS_CONF)*

help:
	@echo Simplistic script to locally deploy a specific NixOS machine configuration to $(NIXOS_CONF)
	@echo Creates a backup of $(NIXOS_CONF) to $(NIXOS_CONF_BACKUP)
	@echo	Usage example:
	@echo	\# make deploy machine=orbit
