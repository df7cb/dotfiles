# find a utf8 locale
if [ "$LANG" ] ; then
	locale -a 2> /dev/null | fgrep -q $LANG || unset LANG
fi
if [ -z "$LANG" ] ; then
	LANG=C
	for locale in `locale -a` ; do
		case $locale in
			de_DE.[uU][tT][fF]*8) LANG=$locale ; break ;;
			*.[uU][tT][fF]*8) LANG=$locale ;;
		esac
	done
fi
export LANG

