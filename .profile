# Myon's profile settings (the non-obnoxious parts, hopefully)

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# Prompt
[ -f /etc/debian_chroot ] && chroot="$(cat /etc/debian_chroot)."
screentitle='\[\ek\u@'"$chroot"'\h\e\\\]'
xtitle='\[\e]0;\u@'"$chroot"'\h:\w\a\]'
prompt='\[\e[1m\][$?] \A \u@'"$chroot"'\h:\w \$\[\e[0m\] '
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
if [ -f /etc/debian_version ]; then
  alias agi="sudo apt install"
  alias agr="sudo apt remove"
  alias autoremove="sudo apt autoremove"
  alias 'build-dep'="sudo apt build-dep"
  alias 'dist-upgrade'="sudo apt dist-upgrade"
  alias update="sudo apt update"
  alias upgrade="sudo apt upgrade"
  alias policy="apt-cache policy"
  alias search="apt-cache search"
  alias show="apt-cache show"
  alias showpkg="apt-cache showpkg"
  alias showsrc="apt-cache showsrc"
fi

# Red Hat
if [ -f /etc/redhat-release ]; then
  alias agi="sudo yum install"
  alias search="yum search"
  alias update="sudo yum check-update"
  alias upgrade="sudo yum upgrade"
fi

# Services
if [ -d /run/systemd/system ]; then
  alias sc='sudo systemctl'
  alias scu='systemctl --user'
  status () { sudo systemctl status --full --no-pager "$@"; }
  do_systemctl () {
    local r
    sudo env -i /bin/systemctl "$@"
    r=$?
    sleep 0.2
    shift # remove start/stop/...
    status "$@"
    return $r
  }
  start   () { do_systemctl start "$@"; }
  stop    () { do_systemctl stop "$@"; }
  reload  () { do_systemctl reload "$@"; }
  restart () { do_systemctl restart "$@"; }
  enable  () { do_systemctl enable "$@"; }
  disable () { do_systemctl disable "$@"; }
else
  start   () { sudo env -i /usr/sbin/service $1 start; }
  stop    () { sudo env -i /usr/sbin/service $1 stop; }
  status  () { sudo        /usr/sbin/service $1 status; }
  reload  () { sudo env -i /usr/sbin/service $1 reload; }
  restart () { sudo env -i /usr/sbin/service $1 restart; }
  enable  () { sudo        /usr/sbin/update-rc.d $1 enable; }
  disable () { sudo        /usr/sbin/update-rc.d $1 disable; }
fi
