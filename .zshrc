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
	preexec() { echo -n "\e]0;$USER@$HOST:$argv\a" }
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

# history settings
HISTSIZE=800
SAVEHIST=500
HISTFILE=~/.bash_history
#setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_NO_STORE
#setopt HIST_SAVE_NO_DUPS
setopt HIST_REDUCE_BLANKS
setopt noPROMPTCR
#setopt SHARE_HISTORY

[ -f $ZDOTDIR/.zshrc-local ] && source $ZDOTDIR/.zshrc-local || true
