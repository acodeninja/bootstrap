# Collide

Two shapes meet. What happens depends on both of them: two circles bounce, two squares
stick, and a circle and a square do something else again. Write it so that adding a
triangle means adding methods and changing nothing that already exists.

## What it teaches

Multiple dispatch: the method is chosen from the types of *all* the arguments, not from
the one to the left of the dot. The problem above is the one that single dispatch cannot
express without somebody checking the other argument by hand — which is the whole reason
double dispatch has a design pattern named after it in other languages.

The second half is what dispatch costs you: nothing checks that every pair of types has a
method. A combination you did not write is a run-time error, not a compile-time one, so the
exhaustiveness the pattern-matching rows give you is the thing being traded away.

## Where it sits

Step 3 on `julia`. It assumes FizzBuzz.

## Not available in

`commonlisp` has it in CLOS and gets [macros](syntactic-macros.md) instead. Everywhere
else this is the visitor pattern, a type switch, or a nested conditional —
and writing it that way in `go` or `java` afterwards is the best argument for the feature.

## Source

Written for this repo. Documented at
[Julia: Methods](https://docs.julialang.org/en/v1/manual/methods/).
