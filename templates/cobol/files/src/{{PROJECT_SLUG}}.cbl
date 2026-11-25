       >>SOURCE FORMAT IS FREE
*> That directive has to be the first line, and those seven leading spaces are
*> part of it: a source-format directive is read in fixed format, where columns
*> 1 to 6 are a sequence number area. Everything after it is free format, which
*> is why nothing else in this file is indented to a magic column.
*>
*> Comments are *> to end of line, and in free format they may start anywhere.
*> The fixed-format alternative -- an asterisk in column 7 -- is not available
*> once the directive above is in force.

*> COBOL divides a program into divisions, in this order, and the names are
*> fixed. IDENTIFICATION says what this is; PROGRAM-ID is the name a caller
*> uses, and it is independent of the filename.
IDENTIFICATION DIVISION.
PROGRAM-ID. {{PROJECT_SLUG}}.

*> DATA DIVISION declares storage, and every variable a program uses is
*> declared here rather than where it is first needed. The LINKAGE SECTION is
*> the part that belongs to the caller: these two fields are not allocated by
*> this program, they are the arguments, which is how a CALL passes anything.
*>
*> 01 is a level number, saying this item is at the top of its hierarchy, and
*> PIC X(32) is a picture clause: thirty-two characters, fixed, space padded.
*> There is no variable-length string here -- a field is the width you declared
*> and an answer that does not fit is truncated in silence.
DATA DIVISION.
LINKAGE SECTION.
01  LS-NAME      PIC X(32).
01  LS-GREETING  PIC X(64).

*> The code, and USING names the linkage fields in the order a caller supplies
*> them. There is no return value: the answer is written into the second
*> argument, which is why this takes two for something that looks like one in
*> and one out.
PROCEDURE DIVISION USING LS-NAME LS-GREETING.
    *> MOVE SPACES clears the field first, because it arrives with whatever the
    *> caller had in it and STRING below only writes as far as it needs.
    MOVE SPACES TO LS-GREETING
    *> STRING concatenates. DELIMITED BY SIZE means "all of this operand" --
    *> without it the default stops at the first space, which for a space
    *> padded field is immediately.
    *>
    *> FUNCTION TRIM strips the padding off the incoming name. Forgetting it
    *> would put thirty-two characters of name into the middle of the greeting.
    STRING "Hello, " DELIMITED BY SIZE
           FUNCTION TRIM(LS-NAME) DELIMITED BY SIZE
           "!" DELIMITED BY SIZE
      INTO LS-GREETING
    *> GOBACK returns to the caller. STOP RUN would end the whole process,
    *> which is wrong for something being CALLed.
    GOBACK.
