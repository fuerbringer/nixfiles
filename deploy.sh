#!/usr/bin/env bash

deploy () {
    NOW=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
    NIXOS_CONF="/etc/nixos/"
    NIXOS_CONF_BACKUP="/tmp/"
    NIXOS_CONF_BACKUP_EXT=".nixos.tar.gz"
    NIXOS_CONF_BACKUP_FILE="$NIXOS_CONF_BACKUP$NOW$NIXOS_CONF_BACKUP_EXT"
    NIXOS_CONF_COMMON="common"
    NIXOS_CONF_MODULES="modules"
    NIXOS_CONF_SECRETS_DIR="secrets"

    if [ -z $1 ]; then
	MACHINE=$(hostname)
    else
	MACHINE=$1
    fi

    if [ ! -d "./$MACHINE" ]; then
	echo -n "Default or specified profile '$MACHINE' doesn't exist."
	return
    fi

    echo "# Replaced by $MACHINE configuration" | sudo tee --append $NIXOS_CONFmeta > /dev/null
    read -p "Copy '$MACHINE' profile to $NIXOS_CONF? " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
	sudo tar czf $NIXOS_CONF_BACKUP_FILE $NIXOS_CONF*
	sudo chmod 0600 $NIXOS_CONF_BACKUP_FILE
	sudo cp -r ./$NIXOS_CONF_COMMON/* $NIXOS_CONF
	sudo cp -r ./$NIXOS_CONF_MODULES/* $NIXOS_CONF
	sudo cp -r ./$NIXOS_CONF_SECRETS_DIR $NIXOS_CONF
	sudo cp -r ./$MACHINE/* $NIXOS_CONF
	echo "Done."
    else
       echo "Skipping ..."
    fi
}

full_deploy () {
    deploy $1
    sudo nixos-rebuild switch
}

get_help () {
    echo "usage: [operation] [machine]"
    echo -e "  deploy\tDeploys specified machine profile without rebuilding."
    echo -e "  full-deploy\tDeploys specified machine profile and rebuilds."
    echo -e "\nnote: Script assumes profile machine name to be hostname when not specified."
}

case "$1" in
    "deploy")
	deploy $2
	;;
    "full-deploy")
	full_deploy $2
	;;
    *)
	echo -e "Please specify operation.\n"
	get_help
	;;
esac
