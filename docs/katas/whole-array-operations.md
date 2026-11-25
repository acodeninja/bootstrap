# Smooth

Replace every value in a sequence with the average of itself and its two neighbours,
leaving the ends alone. Write it with no loop and no index variable — one expression over
the whole array.

Then do it to a two-dimensional grid, averaging over all eight neighbours.

## What it teaches

That the array is the unit of work, not the element. A shifted copy of a sequence minus the
original is the gap between neighbours; adding three shifted copies and dividing is the
smoothing; and a logical index is how you leave the ends alone without an `if`. The loop
you did not write is the lesson.

The second half is where it pays off, because the two-dimensional version is the same
expression with another dimension, and the loop version is not. This is also the shape
[game of life](game-of-life.md) has, which is why that is the follow-on for all three rows.

Each language has its own vocabulary for it — `diff` and recycling in R, `repmat` and
logical indexing in Octave, array sections and `where` in Fortran — and the shared idea is
worth more than any of the spellings.

## Where it sits

Step 3 on `r`, `octave` and `fortran`. It assumes FizzBuzz, and leads to
[bowling](bowling.md) and [game of life](game-of-life.md).

## Not available in

`bqn` does this and more and gets [tacit programming](tacit-programming.md) instead.
`julia` broadcasts and gets [multiple dispatch](multiple-dispatch.md). `numpy` would do it
in Python; the language would not.

## Source

Written for this repo. Documented at
[R: Vectorization](https://cran.r-project.org/doc/manuals/r-release/R-lang.html),
[Octave: Broadcasting](https://docs.octave.org/latest/Broadcasting.html) and
[Fortran array expressions](https://fortran-lang.org/learn/quickstart/arrays_strings/).
