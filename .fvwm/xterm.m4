# .fvwm2rc-xterm.m4 cb 990804

DestroyFunc XTermLO
DestroyFunc XTermRO
DestroyFunc XTermLU
DestroyFunc XTermRU

AddToFunc XTermLO "I" Exec xterm -geometry dnl
	ifelse(WIDTH, 1024, 81x24, WIDTH, 1152, 91x28, 80x25)+0+0
+ "I"     JumpWindow 0 -88

AddToFunc XTermRO "I" Exec xterm -geometry dnl
	ifelse(WIDTH, 1024, 80x24, WIDTH, 1152, 91x28, 80x25)-0+0
+ "I"     JumpWindow 50 -88

AddToFunc XTermLU "I" Exec xterm -geometry dnl
	ifelse(WIDTH, 1024, 81x23, WIDTH, 1152, 91x29, 80x25)+0-94
+ "I"     JumpWindow 0 -43

AddToFunc XTermRU "I" Exec xterm -geometry dnl
	ifelse(WIDTH, 1024, 80x23, WIDTH, 1152, 91x29, 80x25)-0-94
+ "I"     JumpWindow 50 -43

AddToFunc 4XTerm "I" Exec xterm -geometry dnl
			   ifelse(WIDTH, 1024, 81x24, WIDTH, 1152, 91x28, 80x25)+0+0
+ "I" Exec xterm -geometry ifelse(WIDTH, 1024, 80x24, WIDTH, 1152, 91x28, 80x25)-0+0
+ "I" Exec xterm -geometry ifelse(WIDTH, 1024, 81x23, WIDTH, 1152, 91x29, 80x25)+0-94
+ "I" Exec xterm -geometry ifelse(WIDTH, 1024, 80x23, WIDTH, 1152, 91x29, 80x25)-0-94
