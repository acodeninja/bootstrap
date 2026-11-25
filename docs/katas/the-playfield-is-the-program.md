# The counter in the grid

Keep a count somewhere in the playfield, bump it from two different places in the program,
and report it at the end. Then make the program change one of its own instructions while
it runs, so the second pass through a loop does something the first did not.

## What it teaches

That the program and its memory are one grid. `p` writes a cell and `g` reads one, and the
cell it writes may be a cell the pointer is about to execute — so storage, source and
control flow are the same material. Nothing else in this repo can say that.

The practical lesson is housekeeping. You pick the coordinates, so you have to know what
else lives there: the template's own kitchen sink records a real bug where the file grew
past fifty rows and started overwriting the cell holding its failure count. A map of your
own grid is part of the work.

## Where it sits

Step 3 on `befunge`. It assumes [leap years](leap-years.md) — Befunge has no strings, so
FizzBuzz is a sitting rather than ten minutes — and leads to
[Langton's Ant](langtons-ant.md), where the grid is the output as well.

## Not available in

Nothing. Self-modifying code is possible in assembly and absurd in everything else here;
in Befunge it is the ordinary way to keep a variable.

## Source

Written for this repo. `p` and `g` are specified in
[the Funge-98 specification](https://github.com/catseye/Funge-98/blob/master/doc/funge98.markdown).
