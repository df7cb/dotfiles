# $Id$
# .zshenv -> .zprofile (login) -> .zshrc (interactive) -> .zlogin (login)
: ${ZDOTDIR=$HOME}

# prompt and color
case $TERM in
linux*|*vt100*|screen*|cons25)
	prompt="
[%B%{[31m%}%?%{[0m%}%b] %U%n@%m%u:%40<..<%B%{[34m%}%~%{[0m%}%b %#"
	LSCOLOR='--color=auto' ;;
xterm*|rxvt)
	prompt="%{]0;%n@%m:%~%}
[%B%{[31m%}%?%{[0m%}%b] %U%n@%m%u:%40<..<%B%{[34m%}%~%{[0m%}%b %#"
	[ "$console" ] && prompt="%{]0;console@%m:%~%}[%B%{[31m%}%?%{[0m%}%b] %U%n@%m%u:%30<..<%B%{[34m%}%~%{[0m%}%b %#"
	unset console
	LSCOLOR='--color=auto' ;;
*)
	prompt="
[%B%?%b] %U%n@%m%u:%40<..<%B%~%b %#" ;;
esac

source $ZDOTDIR/.env
source $ZDOTDIR/.zshkeys

# internal shell settings
setopt autolist
setopt no_beep

[ -f $ZDOTDIR/.zshrc-local ] && source $ZDOTDIR/.zshrc-local || true
