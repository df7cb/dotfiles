# $Id$
changequote([, ])dnl
define([HOSTNAME], esyscmd([echo -n $HOSTNAME]))dnl
ifelse(HOSTNAME, [], [errprint(Hostname undefined) m4exit(1)])dnl
define([ifdomain], [ifelse(regexp(HOSTNAME, [$1$]), -1, [$3], [$2])])dnl
define([ifndomain], [ifelse(regexp(HOSTNAME, [$1$]), -1, [$2], [$3])])dnl
[#] .ssh/config for host HOSTNAME

ForwardX11 yes
NumberOfPasswordPrompts 3

host fermi.df7cb.de fermi
 hostname fermi.df7cb.de
 forwardagent yes
 ifndomain(df7cb.de, checkHostIP no)
host planck.df7cb.de planck
 hostname planck.df7cb.de
 forwardagent yes
 ifndomain(df7cb.de, proxyCommand ssh -t fermi.df7cb.de nc -q0 %h 22
 checkHostIP no)
 #localForward 5901 localhost:5901
 #remoteForward 16001 localhost:16001
host d096.stw.stud.uni-saarland.de d096 hal.heim-d.uni-sb.de hal
 hostname d096.stw.stud.uni-saarland.de
 forwardagent yes
host d139.stw.stud.uni-saarland.de d139
 hostname d139.stw.stud.uni-saarland.de
 ifndomain(stw.stud.uni-saarland.de, proxyCommand ssh -t hal nc -q0 d139 22)

host liilia.cs.uni-sb.de liilia
 hostname liilia.cs.uni-sb.de
 forwardagent yes
host milhouse.cs.uni-sb.de milhouse
 hostname milhouse.cs.uni-sb.de
 forwardagent yes
host millikan.milhouse.cs.uni-sb.de millikan
 ifdomain(milhouse.cs.uni-sb.de,
 hostname 172.16.170.2
 hostkeyalias millikan.milhouse.cs.uni-sb.de,
 hostname millikan.milhouse.cs.uni-sb.de
 proxycommand ssh milhouse.cs.uni-sb.de bin/linux-intel/nc -q0 172.16.170.2 22)
 forwardagent yes

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
