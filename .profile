# $Id$
# echo .profile ; which bash ; which tcsh ; echo $SHELL

PATH=$PATH:/usr/local/bin:/usr/compat/linux/bin:$HOME/bin
SHELL=`which bash` && exec $SHELL -login
SHELL=`which tcsh` && exec $SHELL
SHELL=/bin/sh
