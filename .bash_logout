# $Id$
#echo .bash_logout

#[ -f ~/dead.letter ] && mv -f ~/dead.letter ~/.dead.letter

#if [ $TERM = 97801 ] ; then 
#	echo -ne "\e[2J"
#	fortune
#fi

# remove .display if we created it
[ -f ~/.display ] && grep -q "pid $$\$" ~/.display && rm -f ~/.display
