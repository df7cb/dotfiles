# $Id$

DestroyFunc XTermLO
DestroyFunc XTermRO
DestroyFunc XTermLU
DestroyFunc XTermRU

ifelse(
WIDTH, 1024, `define(LO,81x24)define(RO,80x24)define(LU,81x23)define(RU,80x23)',
WIDTH.HEIGHT, 1152.864, `define(LO,92x27)define(RO,92x27)define(LU,92x27)define(RU,92x27)',
WIDTH.HEIGHT, 1152.900, `define(LO,92x28)define(RO,92x28)define(LU,92x29)define(RU,92x29)',
WIDTH, 1280, `define(LO,102x33)define(RO,102x33)define(LU,102x33)define(RU,102x33)',
`define(LO,80x25)define(RO,80x25)define(LU,80x25)define(RU,80x25)'
)dnl

AddToFunc XTermLO "I" Exec xterm -geometry LO+0+0
+ "I"     JumpWindow 0 -88

AddToFunc XTermRO "I" Exec xterm -geometry RO-0+0
+ "I"     JumpWindow 50 -88

AddToFunc XTermLU "I" Exec xterm -geometry LU+0-94
+ "I"     JumpWindow 0 -43

AddToFunc XTermRU "I" Exec xterm -geometry RU-0-94
+ "I"     JumpWindow 50 -43

AddToFunc 4XTerm "I" Exec xterm -geometry LO+0+0
+		 "I" Exec xterm -geometry RO-0+0
+		 "I" Exec xterm -geometry LU+0-94
+		 "I" Exec xterm -geometry RU-0-94
