# $Id$
dnl This file will open 4 xterms that occupy the screen neatly.
dnl For a resolution of 1024x480 (on the Sony PCG-C1VE) 2 xterms pop up.

changecom(`')dnl
# width = WIDTH, height = HEIGHT
define(_T, 0+0)dnl  place window at top
define(_B, 0-94)dnl place window at bottom

DestroyFunc XTermLO
DestroyFunc XTermRO
DestroyFunc XTermLU
DestroyFunc XTermRU

ifelse(
WIDTH.HEIGHT, 1024.480, `define(_LO,82x27+_T)define(_RO,81x27-_T)
			 define(_LU,82x27+_T)define(_RU,81x27-_T)',
WIDTH.HEIGHT, 1024.768, `define(_LO,82x24+_T)define(_RO,81x24-_T)
			 define(_LU,82x23+_B)define(_RU,81x23-_B)',
WIDTH.HEIGHT, 1152.864, `define(_LO,92x27+_T)define(_RO,92x27-_T)
			 define(_LU,92x27+_B)define(_RU,92x27-_B)',
WIDTH.HEIGHT, 1152.900, `define(_LO,92x28+_T)define(_RO,92x28-_T)
			 define(_LU,92x29+_B)define(_RU,92x29-_B)',
WIDTH, 1280,		`define(_LO,103x33+_T)define(_RO,103x33-_T)
			 define(_LU,103x33+_B)define(_RU,103x33-_B)',
WIDTH, 1600,		`define(_LO,130x40+_T)define(_RO,129x40-_T)
			 define(_LU,130x40+_B)define(_RU,129x40-_B)',
			`define(_LO,80x25+_T)define(_RO,80x25-_T)
WARNING: screen size?	 define(_LU,80x25+_B)define(_RU,80x25-_B)'
)dnl

AddToFunc XTermLO "I" Exec xterm -geometry _LO
+ "I"     JumpWindow 0 -88

AddToFunc XTermRO "I" Exec xterm -geometry _RO
+ "I"     JumpWindow 50 -88

AddToFunc XTermLU "I" Exec xterm -geometry _LU
+ "I"     JumpWindow 0 -43

AddToFunc XTermRU "I" Exec xterm -geometry _RU
+ "I"     JumpWindow 50 -43

AddToFunc XTerms "I" Exec xterm -geometry _LO
+		 "I" Exec xterm -geometry _RO
ifelse(HEIGHT, 480, `',
+		 "I" Exec xterm -geometry _LU
+		 "I" Exec xterm -geometry _RU
)dnl

DestroyMenu Main
AddToMenu Main	"fvwm2"		Title
ifelse(HEIGHT, 480,
`+		"2 xterms"	Function XTerms
+		"xterm L"	Function XTermLO
+		"xterm R"	Function XTermRO',
`+		"4 xterms"	Function XTerms
+		"xterm LO"	Function XTermLO
+		"xterm RO"	Function XTermRO
+		"xterm LU"	Function XTermLU
+		"xterm RU"	Function XTermRU'
)
+		""		Nop

include(.fvwm2/menus)
