# $Id$

[ "$TERM" -eq unknown ] && [ "$HOST" -eq fsinfo ] && who am i | grep io > /dev/null && TERM=97801

mesg y
finger
