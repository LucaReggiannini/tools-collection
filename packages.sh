#!/bin/bash
if [ -z "$1" ] || [ "$1" == "-h" ] || [ "$1" == "--help" ]; then
	echo '
packages

Description:
	Arch Linux utility based on "pacman" package manager.
	List packages explicitly installed, on a single line and without any additional information.
	You can use this output in a new Arch machine to reinstall your favourite packages easily: just use "sudo pacman -S <package_list>"

Usage: packages [OPTIONS] [...]
	
Options:
	-h --help
		Show this help
	-l --list
		List packages
	-w --write path
		Write package list to file. This option requires a path to a folder. It will automatically a file "/<path>/packages_<date>.txt"
'
elif [ "$1" == "-l" ] || [ "$1" == "--list" ] ; then
	pacman -Qeq | tr "\n" " " && echo ""
elif [ "$1" == "-w" ] || [ "$1" == "--write" ]; then
	if [ -z "$2" ]; then
		echo "ERROR: no path specified after -w, --write!"
	else
		pacman -Qeq | tr "\n"2" " > $2"packages_"$(date +%d-%m-2y_%H:%M:%S)".txt" && echo "" >> $2"packages_"$(date +%d-%m-%y_%H:%M:%S)".txt"
	fi   
	
fi
