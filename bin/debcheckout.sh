#!/bin/sh

set -eu

SRC=$1

# create 1st directory level
mkdir -p $SRC
cd $SRC

# checkout Debian repository into 2nd directory level
( set -x
debcheckout $SRC
cd $SRC
v up
git ctags
)

case $(git remote -v) in
    *github.com/*) # Debian repo is on github, don't try to checkout upstream
        exit
        ;;
esac
cd ..

# checkout upstream repository into 2nd directory level
HOMEPAGE=$(apt-cache showsrc $SRC | awk '/^Homepage:/ { print $2 }')
case $HOMEPAGE in
    *github.com/*)
        set -x
        git clone ${HOMEPAGE%/}.git $SRC.git
        cd $SRC.git
        git ctags
        ;;
esac
