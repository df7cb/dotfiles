# $Id$
# echo .profile ; which bash ; which tcsh ; echo $SHELL

. $HOME/.path

#SHELL=`which zsh` && exec $SHELL -l
SHELL=`which bash` && exec $SHELL -login
# SunOS 4's sh sucks
[ -f /usr/local/bin/bash ] && SHELL=bash exec /usr/local/bin/bash -login
SHELL=`which tcsh` && exec $SHELL
SHELL=/bin/sh
