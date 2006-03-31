# $Id$ vim:ft=sshconfig:
changequote([, ])dnl
define([HOSTNAME], esyscmd([echo -n $HOSTNAME]))dnl
ifelse(HOSTNAME, [], [errprint(Hostname undefined) m4exit(1)])dnl
define([ifdomain], [ifelse(regexp(HOSTNAME, [$1$]), -1, [$3], [$2])])dnl
define([ifndomain], [ifelse(regexp(HOSTNAME, [$1$]), -1, [$2], [$3])])dnl
[#] .ssh/config for host HOSTNAME

ForwardX11 yes
NumberOfPasswordPrompts 3
VerifyHostkeyDNS yes

host *.df7cb.de
 forwardagent yes
 user cb
host fermi.df7cb.de
 checkHostIP no
host planck.df7cb.de
 checkHostIP no
host volta.df7cb.de
 port 23
 checkHostIP no

host *.debian.org *.debian.net
 user myon
 identityfile ~/.priv/myon@debian.org
host merkel.debian.org gluck.debian.org
 forwardagent yes

host osem
 hostname rw4.cs.uni-sb.de
 user osem

host kap?? cip???.studcs.uni-sb.de cip??? xcip?
 user berg

host mars.rz.uni-sb.de
 user chbe002
host stud.uni-sb.de
 user chbe0025

host shell.sourceforge.net
 user df7cb

# vim:ft=sshconfig:
