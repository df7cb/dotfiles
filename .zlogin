# $Id$

[ "$TERM" = unknown ] && [ "$HOST" = fsinfo ] && who am i | grep io > /dev/null && TERM=97801

mesg y
finger

[ -f $ZDOTDIR/.zlogin-local ] && source $ZDOTDIR/.zlogin-local || true
