# $Id$
turn scrolling on
turn word-wrap on
turn auto-import on
turn auto-invite off
turn X off
ifelse( _YTALK_, `3.0', `turn auto-rering on',
	_YTALK_, `3.1', `turn prompt-rering off (new syntax)',
	`errprint(`ERROR: _YTALK_ undefined in .configrc')'
	)
