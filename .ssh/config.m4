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

ifdomain(planck.df7cb.de, # woody chroot planck:/data/debian/woody-root
host woody
 proxycommand super woody.sshd
 HostKeyAlias woody.planck.df7cb.de
host sid
 proxycommand super sid.sshd
 HostKeyAlias woody.planck.df7cb.de)

host d096.stw.stud.uni-saarland.de d096 hal.heim-d.uni-sb.de hal hal.cs
 hostname d096.stw.stud.uni-saarland.de
 forwardagent yes
ifdomain(planck.df7cb.de,host irssi
 hostname d096.stw.stud.uni-saarland.de
 forwardagent yes
 localForward 13331 localhost:13331
 localForward 13332 localhost:13332
 localForward 13333 localhost:13333)
#ifndomain(.uni-sb.de,host hal.cs
# ProxyCommand ssh -C milhouse bin/linux-intel/nc -q0 hal.heim-d.uni-sb.de 22
# HostKeyAlias d096.stw.stud.uni-saarland.de)

host maggie.cs.uni-sb.de maggie
 hostname maggie.cs.uni-sb.de
 forwardagent yes
host milhouse.cs.uni-sb.de milhouse
 hostname milhouse.cs.uni-sb.de
 forwardagent yes

host server.asta.uni-saarland.de
 hostname server.asta.uni-saarland.de
 forwardagent yes
 ifndomain(uni-sb.de, Port 44)

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
