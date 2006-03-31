" increment dns zone serials
nmap _a !!perl -pe '($y,$m,$d) = (localtime)[5,4,3]; $d = sprintf("\%04d\%02d\%02d", $y+1900, $m+1, $d); s/\b(?\!$d)(\d{8})(\d{2})/${d}00/'<cr><c-a>
