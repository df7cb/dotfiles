# Makefile: cb 990719

/etc/profile: /home/cb/.bashrc Makefile
	echo "if test -e .bashrc ; then : ; else" > /etc/profile
	echo "echo 'Reading /etc/profile...'" >> /etc/profile
	cat /home/cb/.bashrc >> /etc/profile
	echo "fi" >> /etc/profile

tgz: rcfile.tgz

rcfile.tgz: .[a-z]*
	tar cfvz rcfile.tgz .[a-z]*
