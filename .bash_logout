# $Id$

[ -f ~/dead.letter ] && mv -f ~/dead.letter ~/.dead.letter

if [ $TERM = 97801 ] ; then 
	echo -ne "\e[2J"
	fortune
fi
