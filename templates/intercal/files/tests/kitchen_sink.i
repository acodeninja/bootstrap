	DON'T  Fifteen passing assertions: the toolbox for solving a kata in INTERCAL.
	DON'T  A line beginning DON'T is abstained, so it never runs and never has
	DON'T  to parse. That is the only comment this language has.
	DON'T  Lines reading "DON'T ok - something" are what the runner turns into
	DON'T  TAP, paired in order with the numerals this program reads out.
	DO ,9 <- #1
	DON'T  ,9 above is the whole assertion mechanism. (100) indexes it with 1
	DON'T  when two values match and with 2 when they do not, and only element
	DON'T  1 exists, so a mismatch ends the program where it stands.

	DON'T ok - an array holds what you put in it
	DO ,1 <- #3
	DO ,1 SUB #2 <- #7
	DO .2 <- ,1 SUB #2
	DO .3 <- #7
	PLEASE DO (100) NEXT
	PLEASE READ OUT #1

	DON'T ok - a subscript counts from one
	DO ,1 SUB #1 <- #5
	DO ,1 SUB #3 <- #6
	DO .2 <- ,1 SUB #1
	DO .3 <- #5
	PLEASE DO (100) NEXT
	PLEASE READ OUT #2

	DON'T ok - a two-dimensional array is a different kind of variable
	DO ;1 <- #2 BY #2
	DO ;1 SUB #1 #2 <- #9
	DO .2 <- ;1 SUB #1 #2
	DO .3 <- #9
	PLEASE DO (100) NEXT
	PLEASE READ OUT #3

	DON'T  There are no strings. A character is its number and nothing else,
	DON'T  and the only way text reaches a terminal is one code at a time.
	DON'T ok - a character is only ever a number here
	DO ,2 <- #2
	DO ,2 SUB #1 <- #72
	DO .2 <- ,2 SUB #1
	DO .3 <- #72
	PLEASE DO (100) NEXT
	PLEASE READ OUT #4

	DON'T ok - joining text means copying elements one at a time
	DO ,2 SUB #2 <- ,2 SUB #1
	DO .2 <- ,2 SUB #2
	DO .3 <- #72
	PLEASE DO (100) NEXT
	PLEASE READ OUT #5

	DON'T ok - comparing text is arithmetic on its character codes
	DO .1 <- #90
	DO .2 <- #72
	PLEASE DO (1010) NEXT
	DO .2 <- .3
	DO .3 <- #18
	PLEASE DO (100) NEXT
	PLEASE READ OUT #6

	DON'T  Mingle and select are the two operators the language is built on,
	DON'T  and both work on bits rather than on values.
	DON'T ok - mingle interleaves the bits of two numbers
	DO .2 <- '#1$#1'
	DO .3 <- #3
	PLEASE DO (100) NEXT
	PLEASE READ OUT #7

	DON'T ok - select keeps only the bits a mask asks for
	DO .2 <- '#5~#3'
	DO .3 <- #1
	PLEASE DO (100) NEXT
	PLEASE READ OUT #8

	DON'T ok - a sixteen-bit variable stops at sixty-five thousand five hundred and thirty-five
	DO .2 <- #65535
	DO .3 <- #65535
	PLEASE DO (100) NEXT
	PLEASE READ OUT #9

	DON'T  There is no loop. NEXT, RESUME and FORGET are the whole of control
	DON'T  flow, and what they move is a stack of return addresses.
	DON'T ok - NEXT pushes a return address and RESUME pops as many as you say
	DO .4 <- #0
	PLEASE DO (300) NEXT
	DO .2 <- .4
	DO .3 <- #1
	PLEASE DO (100) NEXT
	PLEASE READ OUT #10

	DON'T ok - FORGET discards a return address, so RESUME lands further out
	DO .5 <- #3
	PLEASE DO (320) NEXT
	DO .2 <- .5
	DO .3 <- #3
	PLEASE DO (100) NEXT
	PLEASE READ OUT #11

	DON'T ok - a subroutine is a line label reached by NEXT
	DO .1 <- #21
	PLEASE DO (200) NEXT
	DO .2 <- .3
	DO .3 <- #42
	PLEASE DO (100) NEXT
	PLEASE READ OUT #12

	DON'T ok - STASH and RETRIEVE are the only local variables there are
	DO .4 <- #7
	DO STASH .4
	DO .4 <- #8
	PLEASE RETRIEVE .4
	DO .2 <- .4
	DO .3 <- #7
	PLEASE DO (100) NEXT
	PLEASE READ OUT #13

	DON'T  Nothing is raised and nothing is caught. The arithmetic that can
	DON'T  overflow says so in a variable, and the arithmetic that cannot be
	DON'T  done at all ends the program with a numbered complaint.
	DON'T ok - overflow is reported in a variable rather than raised
	DO .1 <- #65535
	DO .2 <- #1
	PLEASE DO (1009) NEXT
	DO .2 <- .4
	DO .3 <- #2
	PLEASE DO (100) NEXT
	PLEASE READ OUT #14

	DON'T  The hour this saves: the number on the right of an array assignment
	DON'T  is how many elements to make, not what to put in them. Reading or
	DON'T  writing one past that count ends the program.
	DON'T ok - dimensioning an array is not assigning to it
	DO ,3 <- #3
	DO ,3 SUB #3 <- #0
	DO .2 <- ,3 SUB #3
	DO .3 <- #0
	PLEASE DO (100) NEXT
	PLEASE READ OUT #15

	PLEASE GIVE UP

(100)	DO .1 <- '?.2$.3'~'#0$#65535'
	PLEASE DO (1020) NEXT
	DO ,9 SUB .1 <- #0
	DO RESUME #1

(300)	DO (310) NEXT
	DO .4 <- #9
	DO RESUME #1
(310)	DO .4 <- #1
	DO RESUME #2

(320)	DO (330) NEXT
	DO .5 <- #1
	DO RESUME #1
(330)	DO FORGET #1
	DO RESUME #1
