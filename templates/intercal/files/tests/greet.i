	DON'T  Nothing names this file. make test splices src after every tests/*.i,
	DON'T  compiles the result and reads the TAP it prints -- so a test file is
	DON'T  found by existing and deleting one is safe. Run it with make test.
	DON'T
	PLEASE DON'T  The array ,9 is declared with one element. That is the assertion
	DON'T  mechanism in full: an index of 1 exists and an index of 2 does not,
	DON'T  so storing through a computed index either works or ends the program.
	DO ,9 <- #1
	DON'T  ,9 is the assertion: 100 indexes it with 1 when two values match
	PLEASE DON'T  and with 2 when they do not, and only element 1 exists.
	DON'T ok - a module's subroutine answers through a shared variable
	DON'T  The line above is the TAP name, not prose: one space after DON'T
	DON'T  then ok, which is what the runner scrapes and pairs with the READ
	DON'T  OUT further down. Every other comment here uses two spaces so that
	PLEASE DON'T  it cannot be mistaken for one.
	DO .1 <- #21
	DON'T  The calling convention, written out: put the argument in .1, jump,
	DON'T  and read the answer out of .3. Nothing is passed and nothing is
	DON'T  returned, so the two halves agree by habit and nothing checks it.
	PLEASE DO (200) NEXT
	DO .2 <- .3
	DO .3 <- #42
	PLEASE DON'T  The routine below compares .2 against .3 and subscripts ,9 with the
	DON'T  result. A mismatch indexes element 2, which does not exist, and the
	DON'T  program stops -- so a failing test is a crash rather than a report.
	PLEASE DO (100) NEXT
	DON'T  READ OUT prints in Roman numerals, which the runner converts. This
	PLEASE DON'T  is how the count reaches the TAP output: there is no other way to
	DON'T  emit a number.
	PLEASE READ OUT #1
	DON'T  GIVE UP ends the program, and it has to come before the spliced
	DON'T  subroutines so that execution never falls into them.
	DO GIVE UP
	PLEASE DON'T  The comparison below. There is no equality operator: it mingles
	DON'T  the two values, selects bits from the result, and leaves 0 only when
	DON'T  they matched -- then 1020 adds one, giving the subscript.
(100)	DO .1 <- '?.2$.3'~'#0$#65535'
	PLEASE DO (1020) NEXT
	DO ,9 SUB .1 <- #0
	DO RESUME #1
