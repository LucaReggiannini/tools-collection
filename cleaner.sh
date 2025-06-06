#!/bin/bash

function help() {

        echo '
cleaner

SYNOPSIS:
        cleaner [OPTIONS]

DESCRIPTION:
        Uninstall unneeded packages, clear caches and unneeded files.
        Uses pacman (for standard repository) and pikaur (for AUR).

OPTIONS:
        -h, --help show this help


'
}

if [ "$1" == "-h" ] || [ "$1" == "--help" ]; then
        help
        exit 0
fi

# Remove unneeded packages
sudo pacman -R $(pacman -Qtdq)

# Removes the entire cache of all packages
yes | sudo pacman -Scc
yes | pikaur -Scc
sudo paccache -r -f

# Manually removes files
sudo rm -rf /tmp/*.*
sudo rm -rf ~/.cache
sudo rm -rf ~/.local/share/pikaur/aur_repos/
sudo rm -rf /var/cache/private/pikaur/aur_repos
