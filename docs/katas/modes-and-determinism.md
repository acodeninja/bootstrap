# Reverse lookup

Write one predicate relating a month number to its name, and use it both ways: number in,
name out, and name in, number out. Then declare, for each direction, how many answers there
can be.

## What it teaches

Modes and determinism as part of a declaration rather than as something a reader infers.
`in` and `out` say which arguments are bound on entry, and `det`, `semidet`, `multi` and
`nondet` say how many solutions there are — exactly one, at most one, at least one, any
number. Getting one wrong is a compile error, which is the whole difference between this
row and `prolog`.

The surprise is where the error lands: passing an already-bound value into an `out` slot
turns a `det` call `semidet`, and the compiler reports the mismatch at the caller rather
than at the thing you think is wrong.

## Where it sits

Step 3 on `mercury`. It assumes FizzBuzz, and leads to
[eight queens](eight-queens.md).

## Not available in

`prolog` writes the same predicate and checks none of this, which is the point of having
both rows. Nothing else here has modes at all.

## Source

Written for this repo. Documented in
[the Mercury language reference](https://www.mercurylang.org/information/doc-latest/mercury_ref/),
under modes and determinism.
