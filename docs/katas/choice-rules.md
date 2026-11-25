# Rota

Three people, three shifts, one week. Nobody works two days running, everybody works at
least once, and one person cannot work Wednesdays. Describe a legal rota and let clingo
produce them.

## What it teaches

Generate and test, as two kinds of rule rather than two phases of a program. A choice rule
says what the candidate assignments are; an integrity constraint — a rule with no head —
says which candidates are not allowed. Between them they define a set of answer sets, and
you never write the search.

It also teaches what grounding means. clingo expands the program over a finite domain
before solving, so every variable has to be bounded by something, and an unbounded one is
an error rather than a long wait. That constraint is why `asp` has no unbounded iteration
and no arbitrary-length output.

## Where it sits

Step 3 on `asp`. It assumes [leap years](leap-years.md) — a string here is one opaque term,
so FizzBuzz is the longer job — and leads to [eight queens](eight-queens.md).

## Not available in

`prolog` and `mercury` reach the same answers by resolution, which searches rather than
models. Nothing else here solves anything for you.

## Source

Written for this repo. Documented in
[the Potassco guide](https://github.com/potassco/guide), under choice rules and
integrity constraints.
