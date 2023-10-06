#!/bin/bash

while getopts "uL:" opt ; do
	case $opt in
	u) ;;
	L) ;; # svn: -L --label
	*) exit 5 ;;
	esac
done
# shift away args
shift $(($OPTIND - 1))

if [ -x /usr/bin/dwdiff ] ; then
	/usr/bin/dwdiff -w '[31;47m' -x '[0m' -y '[32;47m' -z '[0m' \
		-p -d '#-=(){}[]",:;/|'\' \
		-C 3 "$@"
else
	/usr/bin/wdiff -w '[31;47m' -x '[0m' -y '[32;47m' -z '[0m' \
		"$@"
fi
