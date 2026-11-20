9000 REM Subroutines live from line 9000 up, so a test can MERGE this file
9010 REM without its own lines colliding. Arguments are shared variables: set
9020 REM WHOM$ and GOSUB 9100, which leaves the answer in GREETING$.
9100 LET GREETING$ = "Hello, " + WHOM$ + "!"
9110 RETURN
