9000 REM Subroutines live from line 9000 up, so a test can MERGE this file
9001 REM without its own lines colliding. Arguments are shared variables: set
9002 REM WHOM$ and GOSUB 9100, which leaves the answer in GREETING$.
9003 REM
9004 REM REM is the only comment there is, and it is a statement like any
9005 REM other -- so every line of this costs a line number, and line numbers
9006 REM are the addresses GOSUB jumps to. Commenting here is spending the
9007 REM same address space the code uses, which is why the blocks are laid
9008 REM out with gaps: 8000 for the reporter in a test, 9000 up for this.
9009 REM
9010 REM There is no function and nothing is declared. A subroutine is a line
9011 REM number you GOSUB to and a RETURN at the end of it, so it has no name,
9012 REM no parameters and no return value -- the caller and the callee agree
9013 REM by convention on which variables carry what, and nothing checks it.
9014 REM
9015 REM There are no local variables either. Every variable is global, so
9016 REM WHOM$ and GREETING$ are visible to the whole program and a second
9017 REM subroutine using WHOM$ for something else would quietly collide.
9018 REM
9019 REM The dollar sign is part of the name and means the variable holds a
9020 REM string. A name without one holds a number, and the two are different
9021 REM variables even when the letters match.
9100 LET GREETING$ = "Hello, " + WHOM$ + "!"
9110 RETURN
