# $Id$
# .zshenv -> .zprofile (login) -> .zshrc (interactive) -> .zlogin (login)
: ${ZDOTDIR=$HOME}

# prompt and color
case $TERM in
linux*|*vt100*|cons25)	# colored prompt
	prompt="
[%B%{[31m%}%?%{[0m%}%b] %U%n@%m%u:%B%{[34m%}%40<..<%~%{[0m%}%b %#"
	LSCOLOR='--color=auto' ;;
xterm*|rxvt|screen*)	# colored prompt, X window titlebar
	prompt="%{]0;%n@%m:%~%}
[%B%{[31m%}%?%{[0m%}%b] %U%n@%m%u:%B%{[34m%}%40<..<%~%{[0m%}%b %#"
	[ "$console" ] && prompt="%{]0;console@%m:%~%}[%B%{[31m%}%?%{[0m%}%b] %U%n@%m%u:%B%{[34m%}%30<..<%~%{[0m%}%b %#"
	preexec() { echo -n "\e]0;$argv\a" }
	LSCOLOR='--color=auto'
	unset console ;;
*)			# use only terminal stuff
	prompt="
[%B%?%b] %U%n@%m%u:%B%40<..<%~%b %#" ;;
esac

source $ZDOTDIR/.env
source $ZDOTDIR/.zshkeys

# internal shell settings
setopt autolist
setopt no_beep

[ -f $ZDOTDIR/.zshrc-local ] && source $ZDOTDIR/.zshrc-local || true
