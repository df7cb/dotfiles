# $Id$
# echo .profile ; which bash ; which tcsh ; echo $SHELL

. ~/.path

SHELL=`which zsh` && exec $SHELL -l
SHELL=`which bash` && exec $SHELL -login
SHELL=`which tcsh` && exec $SHELL
SHELL=/bin/sh
