# $Id$ vim:ft=sshconfig:
changequote([, ])dnl
define([HOSTNAME], esyscmd([echo -n $HOSTNAME]))dnl
ifelse(HOSTNAME, [], [errprint(Hostname undefined) m4exit(1)])dnl
define([ifdomain], [ifelse(regexp(HOSTNAME, [$1$]), -1, [$3], [$2])])dnl
define([ifndomain], [ifelse(regexp(HOSTNAME, [$1$]), -1, [$2], [$3])])dnl
[#] .ssh/config for host HOSTNAME

#ForwardX11 yes
#HashKnownHosts no
NumberOfPasswordPrompts 3
VerifyHostkeyDNS yes

# df7cb.de
host *.df7cb.de
 forwardagent yes
 forwardX11 yes
 user cb
host fermi.df7cb.de
 checkHostIP no
host planck.df7cb.de
 checkHostIP no
host volta.df7cb.de
 port 23
 checkHostIP no

# debian.org
host *.debian.org *.debian.net *.turmzimmer.net *.zseries.org
 user myon
 identityfile ~/.priv/myon@debian.org
host merkel.debian.org gluck.debian.org
 forwardagent yes

# uni-sb.de
host osem
 hostname rw4.cs.uni-sb.de
 user osem
host *.cs.uni-sb.de *.studcs.uni-sb.de
 forwardX11 yes
host *.studcs.uni-sb.de
 user berg

host mars.rz.uni-sb.de
 user chbe002
host stud.uni-sb.de
 user chbe0025

# misc
host *.sourceforge.net
 user df7cb

# vim:ft=sshconfig:
