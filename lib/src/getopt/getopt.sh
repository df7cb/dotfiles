#!/bin/sh

while getopts "cdDf:hlmMv" opt ; do
	case $opt in
	c) CLEAR=yes ;;
	d) OPTIONS="$OPTIONS -d" ;;
	D) OPTIONS="$OPTIONS -D" ;;
	f) MAILBOX=$OPTARG ;;
	h) OPTIONS="$OPTIONS -h" ;;
	l) LOG=yes ;;
	m) OPTIONS="$OPTIONS -m" ;;
	M) OPTIONS="$OPTIONS -M" ;;
	v) OPTIONS="$OPTIONS -v" ;;
	*) exit 5 ;;
	esac
done
# shift away args
shift $(($OPTIND - 1))

