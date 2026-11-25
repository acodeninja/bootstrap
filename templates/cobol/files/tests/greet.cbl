       >>SOURCE FORMAT IS FREE
*> Nothing names this file. make test compiles and runs every tests/*.cbl and
*> reads the TAP it prints, so a test file is found by existing and deleting one
*> is safe. Run the suite with make test.
*>
*> A test is a whole program, because there is no test framework for COBOL and
*> nothing to build one out of -- a paragraph takes no arguments and returns
*> nothing, so a reusable assertion would have to communicate through shared
*> storage anyway.
IDENTIFICATION DIVISION.
PROGRAM-ID. greet-test.

*> WORKING-STORAGE is this program's own variables, as against the LINKAGE
*> SECTION in the greeter which belongs to its caller. Everything is declared
*> up front with a fixed width.
*>
*> The picture clauses are worth reading one by one. X is a character and 9 is a
*> digit; COMP stores the number in binary rather than as text, which is what
*> you want for anything you do arithmetic on. Z is a digit that prints as a
*> space when it is a leading zero, which is how the count below is turned into
*> text without "0001" appearing in the output.
DATA DIVISION.
WORKING-STORAGE SECTION.
01  WS-NAME        PIC X(32) VALUE "world".
01  WS-GREETING    PIC X(64).
01  WS-TEST-NAME   PIC X(80).
01  WS-COUNT       PIC 9(4) COMP VALUE 0.
01  WS-COUNT-TEXT  PIC Z(4).
01  WS-FAILURES    PIC 9(4) COMP VALUE 0.

PROCEDURE DIVISION.
    *> The plan. It has to agree with the number of results reported below,
    *> because nothing counts them for you and the runner checks.
    DISPLAY "1..1"

    *> CALL invokes a separately compiled program by its PROGRAM-ID, and USING
    *> supplies the fields its LINKAGE SECTION declared, in order. This is the
    *> whole of calling anything: there is no function, no return value, and
    *> the answer comes back in WS-GREETING because that is the field passed
    *> second.
    CALL "{{PROJECT_SLUG}}" USING WS-NAME WS-GREETING

    *> The assertion. FUNCTION TRIM is needed on both sides of a comparison
    *> involving a fixed-width field, because WS-GREETING is space padded to
    *> sixty-four characters and the literal is not.
    *>
    *> PERFORM runs a paragraph and comes back. It passes nothing, so the test
    *> name is handed over by moving it into WS-TEST-NAME first -- which is
    *> what a language with no parameters looks like.
    MOVE "a greeting addresses the name it is given" TO WS-TEST-NAME
    IF FUNCTION TRIM(WS-GREETING) = "Hello, world!"
        PERFORM REPORT-PASS
    ELSE
        PERFORM REPORT-FAIL
    END-IF

    *> RETURN-CODE is a special register that becomes the process exit status,
    *> which is the only thing make test can see. Without this line a failing
    *> assertion would print not ok and the build would still go green.
    MOVE WS-FAILURES TO RETURN-CODE
    GOBACK.

*> Two paragraphs, which are the nearest thing to subroutines here: a name, a
*> body, and a full stop to end it. They share every variable with the code
*> above because there is nowhere else to put anything.
*>
*> Both are duplicated into the kitchen sink beside this file, because a
*> paragraph cannot be shared between two programs. Edit one and the other
*> drifts.
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
