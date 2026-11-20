10 PRINT "1..1"
20 MERGE "src/{{PROJECT_SNAKE}}.bas"
30 LET WHOM$ = "world"
40 GOSUB 9100
50 LET M$ = "a greeting addresses the name it is given"
60 LET P = 0
70 IF GREETING$ = "Hello, world!" THEN LET P = 1
80 GOSUB 8000
90 QUIT
8000 REM report one result: M$ names it, P is 1 when it passed
8010 LET N = N + 1
8020 IF P = 1 THEN PRINT "ok" + STR$(N) + " - " + M$
8030 IF P = 0 THEN PRINT "not ok" + STR$(N) + " - " + M$
8040 RETURN
