	DO ,9 <- #1
	DON'T  ,9 is the assertion: (100) indexes it with 1 when two values match
	DON'T  and with 2 when they do not, and only element 1 exists.
	DON'T ok - a module's subroutine answers through a shared variable
	DO .1 <- #21
	PLEASE DO (200) NEXT
	DO .2 <- .3
	DO .3 <- #42
	PLEASE DO (100) NEXT
	PLEASE READ OUT #1
	DO GIVE UP
(100)	DO .1 <- '?.2$.3'~'#0$#65535'
	PLEASE DO (1020) NEXT
	DO ,9 SUB .1 <- #0
	DO RESUME #1
