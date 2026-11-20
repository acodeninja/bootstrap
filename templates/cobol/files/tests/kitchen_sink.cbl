       >>SOURCE FORMAT IS FREE
*> Fifteen passing assertions: the toolbox for solving a kata in COBOL.
IDENTIFICATION DIVISION.
PROGRAM-ID. kitchen-sink.

DATA DIVISION.
WORKING-STORAGE SECTION.

01  WS-TEST-NAME   PIC X(80).
01  WS-COUNT       PIC 9(4) COMP VALUE 0.
01  WS-COUNT-TEXT  PIC Z(4).
01  WS-FAILURES    PIC 9(4) COMP VALUE 0.

01  WS-I           PIC 9(4) COMP VALUE 0.
01  WS-OUTCOME     PIC X(16).

01  WS-ITEMS.
    05  WS-ITEM    PIC X(1) OCCURS 3 TIMES.

01  WS-LOOKUP.
    05  WS-ENTRY OCCURS 2 TIMES INDEXED BY WS-IDX.
        10  WS-ENTRY-KEY    PIC X(1).
        10  WS-ENTRY-VALUE  PIC 9(1).
01  WS-FOUND       PIC 9(1) VALUE 0.

01  WS-LETTERS.
    05  WS-LETTER  PIC X(1) OCCURS 3 TIMES.
01  WS-SEEN        PIC 9(4) COMP VALUE 0.

01  WS-TEXT        PIC X(32).
01  WS-WORD-ONE    PIC X(16).
01  WS-WORD-TWO    PIC X(16).
01  WS-WORD-THREE  PIC X(16).
01  WS-BUILT       PIC X(32).

01  WS-POINT.
    05  WS-POINT-X PIC 9(1).
    05  WS-POINT-Y PIC 9(1).
01  WS-MOVED.
    05  WS-MOVED-X PIC 9(1).
    05  WS-MOVED-Y PIC 9(1).

01  WS-STATE       PIC X(1).
    88  LOCKED     VALUE "L".
    88  UNLOCKED   VALUE "U".

01  WS-NUMBERS.
    05  WS-NUMBER  PIC 9(2) OCCURS 4 TIMES.
01  WS-WEIGHTED    PIC 9(4) COMP VALUE 0.
01  WS-TOTAL       PIC 9(4) COMP VALUE 0.
01  WS-GAP         PIC S9(4) COMP VALUE 0.
01  WS-WIDEST      PIC S9(4) COMP VALUE 0.

01  WS-INPUT       PIC 9(4) COMP VALUE 0.
01  WS-DOUBLED     PIC 9(4) COMP VALUE 0.

01  WS-SMALL       PIC 9(2) VALUE 0.
01  WS-DIGITS      PIC X(3).
01  WS-THREE-CHARS PIC X(3).
01  WS-TWO-DIGITS  PIC 9(2) VALUE 0.

PROCEDURE DIVISION.
    DISPLAY "1..15"

    MOVE 1 TO WS-NUMBER(1)
    MOVE 2 TO WS-NUMBER(2)
    MOVE 4 TO WS-NUMBER(3)
    MOVE 8 TO WS-NUMBER(4)

*> collections

    MOVE "a" TO WS-ITEM(1)
    MOVE "b" TO WS-ITEM(2)
    MOVE "c" TO WS-ITEM(3)

    MOVE "a table keeps what you put in it, in order" TO WS-TEST-NAME
    IF WS-ITEM(1) = "a" AND WS-ITEM(2) = "b" AND WS-ITEMS = "abc"
        PERFORM REPORT-PASS
    ELSE
        PERFORM REPORT-FAIL
    END-IF

*> There is no map type. A lookup is a table and a SEARCH, and the way a miss
*> announces itself is AT END rather than a value you could mistake for data.
    MOVE "a" TO WS-ENTRY-KEY(1)
    MOVE 2   TO WS-ENTRY-VALUE(1)
    MOVE "b" TO WS-ENTRY-KEY(2)
    MOVE 1   TO WS-ENTRY-VALUE(2)

    MOVE SPACES TO WS-OUTCOME
    SET WS-IDX TO 1
    SEARCH WS-ENTRY
        AT END MOVE "missing" TO WS-OUTCOME
        WHEN WS-ENTRY-KEY(WS-IDX) = "z"
            MOVE "found" TO WS-OUTCOME
    END-SEARCH

    SET WS-IDX TO 1
    SEARCH WS-ENTRY
        AT END MOVE 0 TO WS-FOUND
        WHEN WS-ENTRY-KEY(WS-IDX) = "a"
            MOVE WS-ENTRY-VALUE(WS-IDX) TO WS-FOUND
    END-SEARCH

    MOVE "a lookup for a key that is not there ends AT END" TO WS-TEST-NAME
    IF FUNCTION TRIM(WS-OUTCOME) = "missing" AND WS-FOUND = 2
        PERFORM REPORT-PASS
    ELSE
        PERFORM REPORT-FAIL
    END-IF

*> No set type either, so uniqueness is something you count.
    MOVE "a" TO WS-LETTER(1)
    MOVE "b" TO WS-LETTER(2)
    MOVE "a" TO WS-LETTER(3)

    MOVE 0 TO WS-SEEN
    PERFORM VARYING WS-I FROM 1 BY 1 UNTIL WS-I > 3
        IF WS-LETTER(WS-I) = "a"
            ADD 1 TO WS-SEEN
        END-IF
    END-PERFORM

    MOVE "counting is how you ask what a set would answer" TO WS-TEST-NAME
    IF WS-SEEN = 2
        PERFORM REPORT-PASS
    ELSE
        PERFORM REPORT-FAIL
    END-IF

*> strings

    MOVE "one two three" TO WS-TEXT
    UNSTRING WS-TEXT DELIMITED BY " "
        INTO WS-WORD-ONE WS-WORD-TWO WS-WORD-THREE
    END-UNSTRING

    MOVE "UNSTRING is how a string comes apart" TO WS-TEST-NAME
    IF FUNCTION TRIM(WS-WORD-ONE) = "one"
       AND FUNCTION TRIM(WS-WORD-THREE) = "three"
        PERFORM REPORT-PASS
    ELSE
        PERFORM REPORT-FAIL
    END-IF

    MOVE "abcdef" TO WS-TEXT

    MOVE "a substring is an offset and a length, counting from one"
      TO WS-TEST-NAME
    IF WS-TEXT(1:1) = "a" AND WS-TEXT(1:3) = "abc" AND WS-TEXT(5:2) = "ef"
        PERFORM REPORT-PASS
    ELSE
        PERFORM REPORT-FAIL
    END-IF

    MOVE SPACES TO WS-BUILT
    STRING "one" DELIMITED BY SIZE
           "-" DELIMITED BY SIZE
           "two" DELIMITED BY SIZE
      INTO WS-BUILT
    END-STRING

    MOVE "text is built by STRING into a field that stays its own size"
      TO WS-TEST-NAME
    IF FUNCTION TRIM(WS-BUILT) = "one-two"
       AND FUNCTION LENGTH(FUNCTION TRIM(WS-BUILT)) = 7
        PERFORM REPORT-PASS
    ELSE
        PERFORM REPORT-FAIL
    END-IF

*> types and branching

    MOVE 1 TO WS-POINT-X
    MOVE 2 TO WS-POINT-Y
    MOVE WS-POINT TO WS-MOVED
    MOVE 5 TO WS-MOVED-X

    MOVE "moving a group item copies every field under it" TO WS-TEST-NAME
    IF WS-MOVED-X = 5 AND WS-MOVED-Y = 2 AND WS-POINT-X = 1
        PERFORM REPORT-PASS
    ELSE
        PERFORM REPORT-FAIL
    END-IF

*> A level-88 is the nearest thing to an enumeration: a name for a value, which
*> then reads as a condition rather than as a comparison.
    MOVE "U" TO WS-STATE

    MOVE "a named state is a level-88 condition, not a comparison"
      TO WS-TEST-NAME
    IF UNLOCKED AND NOT LOCKED
        PERFORM REPORT-PASS
    ELSE
        PERFORM REPORT-FAIL
    END-IF

*> EVALUATE is a statement rather than an expression, so every arm assigns.
    MOVE SPACES TO WS-OUTCOME
    EVALUATE TRUE
        WHEN LOCKED
            MOVE "shut" TO WS-OUTCOME
        WHEN UNLOCKED
            MOVE "open" TO WS-OUTCOME
        WHEN OTHER
            MOVE "unknown" TO WS-OUTCOME
    END-EVALUATE

    MOVE "every arm of an EVALUATE assigns its answer" TO WS-TEST-NAME
    IF FUNCTION TRIM(WS-OUTCOME) = "open"
        PERFORM REPORT-PASS
    ELSE
        PERFORM REPORT-FAIL
    END-IF

*> iteration

    MOVE 0 TO WS-WEIGHTED
    PERFORM VARYING WS-I FROM 1 BY 1 UNTIL WS-I > 4
        COMPUTE WS-WEIGHTED = WS-WEIGHTED + WS-I * WS-NUMBER(WS-I)
    END-PERFORM

    MOVE "PERFORM VARYING hands you the subscript as it goes"
      TO WS-TEST-NAME
    IF WS-WEIGHTED = 49
        PERFORM REPORT-PASS
    ELSE
        PERFORM REPORT-FAIL
    END-IF

    MOVE 0 TO WS-WIDEST
    PERFORM VARYING WS-I FROM 1 BY 1 UNTIL WS-I > 3
        COMPUTE WS-GAP = WS-NUMBER(WS-I + 1) - WS-NUMBER(WS-I)
        IF WS-GAP > WS-WIDEST
            MOVE WS-GAP TO WS-WIDEST
        END-IF
    END-PERFORM

    MOVE "a table can be read two entries at a time" TO WS-TEST-NAME
    IF WS-WIDEST = 4
        PERFORM REPORT-PASS
    ELSE
        PERFORM REPORT-FAIL
    END-IF

*> functions

*> Nothing here can be handed to anything: a paragraph takes no arguments and
*> returns nothing, so it reads and writes WORKING-STORAGE instead. A separate
*> program CALLed with USING is the only thing that has parameters.
    MOVE 4 TO WS-INPUT
    PERFORM DOUBLE-THE-INPUT

    MOVE "a paragraph has no arguments, so it shares the data"
      TO WS-TEST-NAME
    IF WS-DOUBLED = 8
        PERFORM REPORT-PASS
    ELSE
        PERFORM REPORT-FAIL
    END-IF

    MOVE 0 TO WS-TOTAL
    PERFORM VARYING WS-I FROM 1 BY 1 UNTIL WS-I > 4
        ADD WS-NUMBER(WS-I) TO WS-TOTAL
    END-PERFORM

    MOVE "a total is accumulated, because there is no fold"
      TO WS-TEST-NAME
    IF WS-TOTAL = 15
        PERFORM REPORT-PASS
    ELSE
        PERFORM REPORT-FAIL
    END-IF

*> errors

*> Failure is a condition on the statement that failed, not an exception thrown
*> past it. ON SIZE ERROR fires and the target keeps the value it had.
    MOVE 0 TO WS-SMALL
    MOVE SPACES TO WS-OUTCOME
    COMPUTE WS-SMALL = 99 + 1
        ON SIZE ERROR
            MOVE "refused" TO WS-OUTCOME
        NOT ON SIZE ERROR
            MOVE "accepted" TO WS-OUTCOME
    END-COMPUTE

    MOVE "12x" TO WS-DIGITS

    MOVE "an answer that will not fit is refused, not stored"
      TO WS-TEST-NAME
    IF FUNCTION TRIM(WS-OUTCOME) = "refused" AND WS-SMALL = 0
       AND WS-DIGITS IS NOT NUMERIC
        PERFORM REPORT-PASS
    ELSE
        PERFORM REPORT-FAIL
    END-IF

*> gotchas

*> The hour this saves: an answer that does not fit is not an error unless you
*> asked for one. Digits go from the left and characters from the right, in
*> silence. A literal too big for its target draws a warning from -Wall; a
*> field too big for its target does not, which is the half that bites.
    MOVE 0 TO WS-TWO-DIGITS
    MOVE "abcdef" TO WS-TEXT
    COMPUTE WS-TWO-DIGITS = WS-NUMBER(4) * WS-NUMBER(4) * 2
    MOVE WS-TEXT TO WS-THREE-CHARS

    MOVE "an answer that does not fit is truncated in silence"
      TO WS-TEST-NAME
    IF WS-TWO-DIGITS = 28 AND WS-THREE-CHARS = "abc"
        PERFORM REPORT-PASS
    ELSE
        PERFORM REPORT-FAIL
    END-IF

    MOVE WS-FAILURES TO RETURN-CODE
    GOBACK.

DOUBLE-THE-INPUT.
    COMPUTE WS-DOUBLED = WS-INPUT * 2.

REPORT-PASS.
    ADD 1 TO WS-COUNT
    MOVE WS-COUNT TO WS-COUNT-TEXT
    DISPLAY "ok " FUNCTION TRIM(WS-COUNT-TEXT) " - "
            FUNCTION TRIM(WS-TEST-NAME).

REPORT-FAIL.
    ADD 1 TO WS-COUNT
    ADD 1 TO WS-FAILURES
    MOVE WS-COUNT TO WS-COUNT-TEXT
    DISPLAY "not ok " FUNCTION TRIM(WS-COUNT-TEXT) " - "
            FUNCTION TRIM(WS-TEST-NAME).
