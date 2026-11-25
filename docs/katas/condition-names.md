# Account state

An account record holds a one-character status. Give that field a name per state, branch on
the names rather than on the character, and compute a balance in a field narrow enough that
one of your test cases will not fit in it.

## What it teaches

Level-88 condition names: a state becomes something you read as a condition rather than
compare as a value, which is the closest thing COBOL has to an enumerated type and reads
better than the `if` it replaces. `EVALUATE TRUE` is the multi-way branch over them, and
because it is a statement rather than an expression, every arm has to assign.

The second half is the one that costs people a day in the real world. A `PIC` field has a
fixed width and an answer that does not fit is truncated in silence — unless you ask for
`ON SIZE ERROR`, which is how the language reports a refusal at all.

## Where it sits

Step 3 on `cobol`. It assumes FizzBuzz.

## Not available in

Fixed-width decimal arithmetic that truncates quietly is specific to this row, and so is
reading a state as a condition. `pascal` and `ada` have real enumerated types, which is
the comparison to draw.

## Source

Written for this repo. Documented in
[the GnuCOBOL manual](https://gnucobol.sourceforge.io/doc/gnucobol.html), under level 88
and ON SIZE ERROR.
