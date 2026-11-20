	DON'T  Subroutines live here, reached by DO (200) NEXT from a test. The
	DON'T  runner splices this file after the test, so execution never falls
	DON'T  into it: the test's GIVE UP comes first.
	DON'T  Arguments and answers are shared variables, because there are no
	DON'T  parameters: set .1, and (200) leaves twice it in .3.
(200)	DO .2 <- #2
	PLEASE DO (1030) NEXT
	DO RESUME #1
