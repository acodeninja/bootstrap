1 REM Fifteen passing assertions: the toolbox for solving a kata in BASIC.
10 PRINT "1..15"
20 ON ERROR GOSUB 8100
30 REM collections
40 DIM ITEMS$(3)
50 LET ITEMS$(0) = "a"
60 LET ITEMS$(1) = "b"
70 LET ITEMS$(2) = "c"
80 LET M$ = "an array keeps what you put in it, in order"
90 LET P = 0
100 IF ITEMS$(0) = "a" AND ITEMS$(1) = "b" AND ITEMS$(2) = "c" THEN LET P = 1
110 GOSUB 8000
120 REM There is no map. A key is a position in one array and the value is the
130 REM same position in another, so a miss leaves whatever you set first.
140 DIM KEYS$(2)
150 DIM VALS(2)
160 LET KEYS$(0) = "a"
170 LET VALS(0) = 2
180 LET KEYS$(1) = "b"
190 LET VALS(1) = 1
200 LET FOUND = 0 - 1
210 FOR I = 0 TO 1
220 IF KEYS$(I) = "a" THEN LET FOUND = VALS(I)
230 NEXT I
240 LET MISSED = 0 - 1
250 FOR I = 0 TO 1
260 IF KEYS$(I) = "z" THEN LET MISSED = VALS(I)
270 NEXT I
280 LET M$ = "a lookup that misses leaves the answer you set first"
290 LET P = 0
300 IF FOUND = 2 AND MISSED = 0 - 1 THEN LET P = 1
310 GOSUB 8000
320 REM No set type either, so uniqueness is something you count.
330 DIM LETTERS$(3)
340 LET LETTERS$(0) = "a"
350 LET LETTERS$(1) = "b"
360 LET LETTERS$(2) = "a"
370 LET SEEN = 0
380 FOR I = 0 TO 2
390 IF LETTERS$(I) = "a" THEN LET SEEN = SEEN + 1
400 NEXT I
410 LET M$ = "counting is how you ask what a set would answer"
420 LET P = 0
430 IF SEEN = 2 THEN LET P = 1
440 GOSUB 8000
450 REM strings
460 LET T$ = "one two three"
470 LET AT = INSTR(T$, " ")
480 LET FIRST$ = LEFT$(T$, AT - 1)
490 LET REST$ = MID$(T$, AT + 1, LEN(T$) - AT)
500 LET M$ = "a string comes apart with INSTR, LEFT$ and MID$"
510 LET P = 0
520 IF AT = 4 AND FIRST$ = "one" AND REST$ = "two three" THEN LET P = 1
530 GOSUB 8000
540 LET T$ = "abcdef"
550 LET M$ = "MID$ takes a start and a count, beginning at one"
560 LET P = 0
570 IF MID$(T$, 1, 3) = "abc" AND MID$(T$, 2, 1) = "b" THEN LET P = 1
580 IF RIGHT$(T$, 2) <> "ef" THEN LET P = 0
590 GOSUB 8000
600 LET B$ = "one" + "-" + "two"
610 LET M$ = "text is joined with + and a character repeats with STRING$"
620 LET P = 0
630 IF B$ = "one-two" AND STRING$(3, "a") = "aaa" AND LEN(B$) = 7 THEN LET P = 1
640 GOSUB 8000
650 REM types and branching
660 REM There are no records. A row is one position across several arrays,
670 REM which is why the lookup above needed two of them.
680 DIM XS(2)
690 DIM YS(2)
700 LET XS(0) = 1
710 LET YS(0) = 2
720 LET XS(1) = XS(0)
730 LET YS(1) = YS(0)
740 LET XS(1) = 5
750 LET M$ = "a record is one position across parallel arrays"
760 LET P = 0
770 IF XS(1) = 5 AND XS(0) = 1 AND YS(1) = 2 THEN LET P = 1
780 GOSUB 8000
790 LET LOCKED = 0
800 LET UNLOCKED = 1
810 LET STATE = UNLOCKED
820 LET M$ = "a named state is a variable you agree to treat as one"
830 LET P = 0
840 IF STATE = UNLOCKED AND STATE <> LOCKED THEN LET P = 1
850 GOSUB 8000
860 REM IF assigns in each arm; ON ... GOSUB is the computed form of the same
870 REM choice, counting its targets from one.
880 LET OUTCOME$ = ""
890 IF STATE = LOCKED THEN LET OUTCOME$ = "shut"
900 IF STATE = UNLOCKED THEN LET OUTCOME$ = "open"
910 ON STATE + 1 GOSUB 8200, 8220
920 LET M$ = "a branch assigns, and ON ... GOSUB picks one by number"
930 LET P = 0
940 IF OUTCOME$ = "open" AND PICKED$ = "second" THEN LET P = 1
950 GOSUB 8000
960 REM iteration
970 DIM NS(4)
980 LET NS(0) = 1
990 LET NS(1) = 2
1000 LET NS(2) = 4
1010 LET NS(3) = 8
1020 LET W = 0
1030 FOR I = 0 TO 3
1040 LET W = W + (I + 1) * NS(I)
1050 NEXT I
1060 LET M$ = "FOR hands you the index as it counts"
1070 LET P = 0
1080 IF W = 49 THEN LET P = 1
1090 GOSUB 8000
1100 LET WIDEST = 0
1110 FOR I = 0 TO 2
1120 LET G = NS(I + 1) - NS(I)
1130 IF G > WIDEST THEN LET WIDEST = G
1140 NEXT I
1150 LET M$ = "a sequence is walked two at a time by reading I and I plus one"
1160 LET P = 0
1170 IF WIDEST = 4 THEN LET P = 1
1180 GOSUB 8000
1190 REM functions
1200 REM DEF FN names an expression, and that is the whole of it: a call will
1210 REM not nest inside another call, and a GOSUB takes no arguments at all.
1220 DEF FNDOUBLE(X) = X * 2
1230 LET M$ = "DEF FN names an expression that will not nest in itself"
1240 LET P = 0
1242 LET ONCE = FNDOUBLE(4)
1244 LET TWICE = FNDOUBLE(ONCE)
1250 IF ONCE = 8 AND TWICE = 16 THEN LET P = 1
1260 GOSUB 8000
1270 LET TOT = 0
1280 FOR I = 0 TO 3
1290 LET TOT = TOT + NS(I)
1300 NEXT I
1310 LET M$ = "a total is accumulated, because there is no fold"
1320 LET P = 0
1330 IF TOT = 15 THEN LET P = 1
1340 GOSUB 8000
1350 REM errors
1360 REM Nothing refuses anything: VAL answers zero for text that is not a
1370 REM number, so checking is yours to do. A real error needs ON ERROR GOSUB,
1380 REM set at line 20, which runs and then carries on where it left off.
1390 LET BAD = VAL("nope")
1400 LET GOOD = VAL("42")
1410 LET TRAPPED = 0
1420 LET Z = 1 / 0
1430 LET M$ = "VAL answers zero rather than refusing, and errors need a trap"
1440 LET P = 0
1450 IF BAD = 0 AND GOOD = 42 AND TRAPPED = 1 THEN LET P = 1
1460 GOSUB 8000
1470 REM gotchas
1480 REM The hour this saves: no variable is ever declared, so a name you
1490 REM mistyped is not an error. It is a new variable, and it is worth zero.
1500 LET TOTAL = 7
1510 LET M$ = "a mistyped variable is a new variable worth zero"
1520 LET P = 0
1530 IF TOTAL = 7 AND TOTL = 0 THEN LET P = 1
1540 GOSUB 8000
1550 QUIT
8000 REM report one result: M$ names it, P is 1 when it passed
8010 LET N = N + 1
8020 IF P = 1 THEN PRINT "ok" + STR$(N) + " - " + M$
8030 IF P = 0 THEN PRINT "not ok" + STR$(N) + " - " + M$
8040 RETURN
8100 LET TRAPPED = 1
8110 RETURN
8200 LET PICKED$ = "first"
8210 RETURN
8220 LET PICKED$ = "second"
8230 RETURN
