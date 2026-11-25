	DON'T  Subroutines live here, reached by DO 200 NEXT from a test. The
	DON'T  runner splices this file after the test, so execution never falls
	PLEASE DON'T  into it: the test's GIVE UP comes first.
	DON'T  Arguments and answers are shared variables, because there are no
	DON'T  parameters: set .1, and 200 leaves twice it in .3.
	PLEASE DON'T
	DON'T  DON'T is the only comment this language has. It is not comment
	DON'T  syntax: it is an abstained statement, so the line is compiled and
	PLEASE DON'T  then never executed. Keep the two spaces after it -- the
	DON'T  runner reads a line beginning DON'T, one space, then ok as a TAP
	DON'T  result, so prose must never start that way.
	PLEASE DON'T
	DON'T  An abstained line is still a statement, which has a consequence
	DON'T  nothing else in this repo has: the compiler requires between a
	PLEASE DON'T  fifth and a third of statements to say PLEASE rather than
	DON'T  DO, and refuses the program otherwise. Adding comments therefore
	DON'T  means adding politeness, which is why some of these are PLEASE.
	PLEASE DON'T
	DON'T  A label in brackets at the start of a line is the only name there
	DON'T  is. There are no functions: you jump to a label with NEXT and come
	PLEASE DON'T  back with RESUME, so a subroutine has no parameters and no
	DON'T  return value. Write a bracketed number in prose and the compiler
	DON'T  reads it as a label, so these comments spell them out instead.
	PLEASE DON'T
	DON'T  There are no strings either: a character is its number and nothing
	DON'T  else, which is why this greeter doubles a number instead of
	PLEASE DON'T  building any text.
	DON'T
	DON'T  .1 and .2 are sixteen-bit variables; the dot is part of the name,
	DON'T  and a colon would make it thirty-two. # introduces a constant.
(200)	DO .2 <- #2
	PLEASE DO (1030) NEXT
	DO RESUME #1
