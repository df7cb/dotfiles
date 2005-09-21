# $Id$ vim:ft=sshconfig:
changequote([, ])dnl
define([HOSTNAME], esyscmd([echo -n $HOSTNAME]))dnl
ifelse(HOSTNAME, [], [errprint(Hostname undefined) m4exit(1)])dnl
define([ifdomain], [ifelse(regexp(HOSTNAME, [$1$]), -1, [$3], [$2])])dnl
define([ifndomain], [ifelse(regexp(HOSTNAME, [$1$]), -1, [$2], [$3])])dnl
[#] .ssh/config for host HOSTNAME

ForwardX11 yes
NumberOfPasswordPrompts 3

#ifdomain(intertalk.cs.uni-sb.de,
#  Host es05
#  Hostname rw4
#  User es05
#  ProxyCommand ssh knecht /RW/users/cb/bin/linux-intel/nc -q0 %h %p
# Host knecht.cs.uni-sb.de knecht
#  ProxyCommand none
# Host *
#  ProxyCommand ssh knecht /RW/users/cb/bin/linux-intel/nc -q0 %h %p
#)

host fermi.df7cb.de fermi
 hostname fermi.df7cb.de
 forwardagent yes
 ifndomain(df7cb.de, checkHostIP no)
host planck.df7cb.de planck
 hostname planck.df7cb.de
 forwardagent yes
 checkHostIP no
host meitner.df7cb.de meitner
 hostname meitner.df7cb.de
 forwardagent yes

host meitner.vpn.df7cb.de
 hostkeyalias meitner.df7cb.de
 hostname 10.7.1.1
 forwardagent yes

host *.debian.org *.debian.net
 user myon
 identityfile ~/.priv/myon@debian.org

host d096.stw.stud.uni-saarland.de d096 hal.heim-d.uni-sb.de hal
 hostname d096.stw.stud.uni-saarland.de
 forwardagent yes

host knecht.cs.uni-sb.de knecht
 hostname knecht.cs.uni-sb.de
host es05
 hostname rw4.cs.uni-sb.de
 user es05

host server.asta.uni-saarland.de
 hostname server.asta.uni-saarland.de
 forwardagent yes

host kap?? cip???.studcs.uni-sb.de cip??? xcip?
 user berg

host mars
 user chbe002
 hostname mars.rz.uni-sb.de
host stud stud.uni-sb.de
 user chbe0025
 hostname stud.uni-sb.de

host hamberg hamberg.it.uu.se
 hostname hamberg.it.uu.se
 user cberg

host shell.sourceforge.net
 user df7cb

# vim:ft=sshconfig:
