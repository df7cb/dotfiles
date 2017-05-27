# Myon's profile settings (the non-obnoxious parts, hopefully)

# Prompt
[ -f /etc/debian_chroot ] && chroot="$(cat /etc/debian_chroot)."
screentitle="\\ek\u@$chroot\h\e\\"
xtitle="\[\e]0;\u@$chroot\h:\w\007\]"
prompt="\\[\e[1m\\][\$?] \A \u@$chroot\h:\w \\$\\[\e[0m\\] "
case $TERM in
  screen*) PS1="$screentitle$xtitle$prompt" ;;
  xterm*|rxvt*|cygwin) PS1="$xtitle$prompt" ;;
  *) PS1="$prompt" ;;
esac
unset chroot screentitle xtitle prompt

# Shell
HISTCONTROL='erasedups'
HISTIGNORE="..:[bf]g:cd:l:ls"
unset ignoreeof
shopt -s extglob no_empty_cmd_completion

# Environment
export EDITOR=vi
export PAGER=less

# Aliases
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias j='jobs -l'
alias l='ls -al'
alias ls='ls -F --color=auto'
alias md=mkdir
alias o='$PAGER'
alias pat='sudo puppet agent -t'
alias tree='tree -F'
alias rd=rmdir

# Debian
alias agi="sudo apt-get install"
alias agr="sudo apt-get remove"
alias 'build-dep'="sudo apt-get build-dep"
alias 'dist-upgrade'="sudo apt-get dist-upgrade"
alias update="sudo apt-get update"
alias policy="apt-cache policy"
alias search="apt-cache search"
alias show="apt-cache show"
alias showpkg="apt-cache showpkg"
alias showsrc="apt-cache showsrc"
alias upgrade="sudo apt-get upgrade"

# Services
if [ -d /run/systemd/system ]; then
  start   () { sudo env -i /bin/systemctl start "$@";   status "$@"; }
  stop    () { sudo env -i /bin/systemctl stop "$@";    status "$@"; }
  status  () { sudo        /bin/systemctl status -l "$@"; }
  reload  () { sudo env -i /bin/systemctl reload "$@";  status "$@"; }
  restart () { sudo env -i /bin/systemctl restart "$@"; status "$@"; }
  enable  () { sudo        /bin/systemctl enable "$@"; }
  disable () { sudo        /bin/systemctl disable "$@"; }
  alias sc='sudo systemctl'
else
  start   () { sudo env -i /usr/sbin/service $1 start; }
  stop    () { sudo env -i /usr/sbin/service $1 stop; }
  status  () { sudo        /usr/sbin/service $1 status; }
  reload  () { sudo env -i /usr/sbin/service $1 reload; }
  restart () { sudo env -i /usr/sbin/service $1 restart; }
  enable  () { sudo        /usr/sbin/update-rc.d $1 enable; }
  disable () { sudo        /usr/sbin/update-rc.d $1 disable; }
fi
