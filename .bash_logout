# $Id$
#echo .bash_logout

#[ -f ~/dead.letter ] && mv -f ~/dead.letter ~/.dead.letter

#if [ $TERM = 97801 ] ; then 
#	echo -ne "\e[2J"
#	fortune
#fi

# remove our .display entry
if [ -f ~/.display ] ; then
	grep -v "pid $$ " ~/.display > ~/.display.tmp
	/bin/mv -f ~/.display.tmp ~/.display
	[ -s ~/.display ] || rm -f ~/.display
fi
