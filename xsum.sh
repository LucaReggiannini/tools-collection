#!/bin/bash

function help() {

	echo '
xsum

SYNOPSIS: 
	xsum [OPTIONS] [FILE]

DESCRIPTION:
	Calculates (in order) md5, sha1 and sha256 of a file.
	Prints results without format or additional informations: this is usefull when putting hashes in a report
	
OPTIONS:
	-h --help
		Show the manual

NOTE:
	When "*" (wildcard) is used without quotes to match multiple files (example: *.pdf) Bash will automatically expand the parameter (for more informations see "bash filename expansion" at https://www.gnu.org/software/bash/manual/bash.html#Filename-Expansion )
'
}

if [ -z "$1" ]; then
	echo "Error: no FILE argument given"
	help
	exit 1
fi

if [ "$1" == "-h" ] || [ "$1" == "--help" ]; then
	help
	exit 0
fi

for file in "$@"; do
	if [ -f "${file}" ]; then
		echo "$file" 
		md5sum "$file" | grep -Eo "^\w+\s"
		sha1sum "$file" | grep -Eo "^\w+\s"
		sha256sum "$file" | grep -Eo "^\w+\s"
	fi
done

exit 0