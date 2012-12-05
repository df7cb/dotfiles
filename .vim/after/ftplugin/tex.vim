"" xdvi source specials integration by mah@wjpserver.cs.uni-sb.de
""map _g :exe 'silent !xdvi -editor "vim --servername ' . v:servername . ' --remote +\%l \%f" -sourceposition ' . line (".") . expand("%") . " " . expand("%:r") . ".dvi &" \| redraw!<cr>
""map <F7> :exe 'silent !xdvi -editor "vim --servername ' . v:servername . ' --remote +\%l \%f" -sourceposition ' . line (".") . expand("%") . " " . expand("%:r") . ".dvi &" \| redraw!<cr>
"fu! GetDVIName()
"	let a = system("grep -l '\\@input{" . expand("%:r") . ".aux}' *.aux")
"	let a = substitute(a,"\n",'','g')
"	if a == ''
"		return expand("%:r") . '.dvi'
"	else
"		return fnamemodify(a,":r") . '.dvi'
"	endif
"endfu
"" xdvi config (TODO: killall -USR1 xdvi?)
"map W :exe 'silent !xdvi -editor "vim --servername ' . v:servername . ' --remote +\%l \%f" -sourceposition ' . line (".") . expand("%") . " " . GetDVIName() . " &" \| redraw!<cr>
"" kdvi config
""map W :exe 'silent !kdvi --unique file:' . GetDVIName() . "\\#src:" . line (".") . expand("%") . " &" \| redraw!<cr>
"nmap L MW

iab \\i \begin{itemize}<cr>\item
iab \i \item
iab \\I \end{itemize}
iab \\f \begin{frame}<cr>\frametitle{
iab \\F \end{frame}

"set keymap=tex
