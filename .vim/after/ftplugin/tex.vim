" xdvi source specials integration by mah@wjpserver.cs.uni-sb.de
"map _g :exe 'silent !xdvi -editor "vim --servername ' . v:servername . ' --remote +\%l \%f" -sourceposition ' . line (".") . expand("%") . " " . expand("%:r") . ".dvi &" \| redraw!<cr>
"map <F7> :exe 'silent !xdvi -editor "vim --servername ' . v:servername . ' --remote +\%l \%f" -sourceposition ' . line (".") . expand("%") . " " . expand("%:r") . ".dvi &" \| redraw!<cr>
fu! GetDVIName()
	let a = system("grep -l '\\@input{" . expand("%:r") . ".aux}' *.aux")
	let a = substitute(a,"\n",'','g')
	if a == ''
		return expand("%:r") . '.dvi'
	else
		return fnamemodify(a,":r") . '.dvi'
	endif
endfu
" TODO killall -USR1 xdvi ??
map W :exe 'silent !xdvi -editor "vim --servername ' . v:servername . ' --remote +\%l \%f" -sourceposition ' . line (".") . expand("%") . " " . GetDVIName() . " &" \| redraw!<cr>

map _i i\begin{itemize}<cr>\item <esc>mi}O\end{itemize}<esc>`i
