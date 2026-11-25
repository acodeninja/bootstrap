1 REM Nothing names this file. make test runs every tests/*.bas through the
2 REM interpreter and reads the TAP it prints, so a test file is found by
3 REM existing and deleting one is safe. Run the suite with make test.
4 REM
5 REM TAP has to be printed by hand because the interpreter exits 0 whatever
6 REM happens -- including when it dies half way through a program. The plan
7 REM below says how many results to expect, and the runner checks it.
10 PRINT "1..1"
11 REM MERGE reads another program into this one at its own line numbers,
12 REM which is the whole of the module system: there is no import, so the
13 REM subroutines arrive as lines 9000 and up and are then callable.
20 MERGE "src/{{PROJECT_SNAKE}}.bas"
21 REM The calling convention, written out: set the input variable, jump, and
22 REM read the output variable. GOSUB takes a line number and nothing else,
23 REM so the 9100 here and the 9100 in the greeter are coupled by hand.
30 LET WHOM$ = "world"
40 GOSUB 9100
41 REM The expected value is compared with IF, and the result is carried to
42 REM the reporter in P because a subroutine cannot be passed anything. M$
43 REM is the test name, and it is what a failure prints.
50 LET M$ = "a greeting addresses the name it is given"
60 LET P = 0
70 IF GREETING$ = "Hello, world!" THEN LET P = 1
80 GOSUB 8000
90 QUIT
8000 REM report one result: M$ names it, P is 1 when it passed
8001 REM
8002 REM This reporter is duplicated into the kitchen sink beside this file,
8003 REM because there is nothing to share it through -- MERGE would collide
8004 REM with the lines it already has. Edit one and the other drifts.
8005 REM
8006 REM N counts the results. It starts at zero because an unset numeric
8007 REM variable is zero rather than an error, which is the same rule that
8008 REM makes a typo a new variable worth nothing.
8010 LET N = N + 1
8020 IF P = 1 THEN PRINT "ok" + STR$(N) + " - " + M$
8030 IF P = 0 THEN PRINT "not ok" + STR$(N) + " - " + M$
8040 RETURN
