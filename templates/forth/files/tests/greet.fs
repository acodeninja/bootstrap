\ Nothing names this file. `make test` hands every tests/*.fs to gforth in turn
\ and reads the TAP each one prints, so a new test file is found by existing.
\ Run the lot with `make test`, or one of them with
\ `make shell` then `gforth tests/greet.fs -e bye`.
\
\ Both requires are needed and the order matters: tester.fs defines T{ -> }T,
\ and the src file defines the word being tested. `require` loads a file once
\ however many times it is asked for, which is what makes this safe.
require ./tester.fs
require ../src/{{PROJECT_SNAKE}}.fs

\ TAP opens with the number of assertions this file is about to make, and the
\ runner compares that number against the ok lines it counted. Add an assertion
\ and this line has to change with it -- there is no discovery to do it for you,
\ and a plan that disagrees with reality is a failure even when every
\ assertion passed.
1 plan

\ One assertion, and it reads left to right: the code runs, -> separates it from
\ what the code should have left on the stack, and }T compares the two.
\
\ `compare` leaves 0 when two strings match, so 0 is the expected value here
\ rather than a true flag. A true flag in Forth is -1 and not 1, which matters
\ the moment you do arithmetic on one.
\
\ The text after }T, to the end of the line, is the name of the test -- that is
\ what TAP prints and what a failure shows. So nothing else can share this line:
\ a \ comment here would be swallowed into the name rather than ignored.
T{ s" world" greet s" Hello, world!" compare -> 0 }T a greeting addresses the name it is given

\ Prints the summary the runner reads, and exits non-zero if anything failed.
tap-done
