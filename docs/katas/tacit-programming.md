# Mean, point-free

Write the arithmetic mean of a list. Then write it again with no argument named anywhere —
no `x`, no braces, just functions combined into one function.

Then do the same for "the largest gap between consecutive items".

## What it teaches

That a function can be built out of functions rather than out of statements about a value.
A 2-train composes, a 3-train forks — hand both halves the same argument and combine their
answers — and once those two shapes are in your hands most one-line definitions stop
needing a variable at all.

The second half needs a shift as well as a train, which is where the other BQN habit comes
in: lookahead is the list minus its own shifted copy, with no cursor to step. Between
trains and shifts there is no iteration left to write.

Learning when *not* to go tacit is part of it. A train that nobody can read is worse than
a block with a named argument, and knowing where that line is for you is the actual
outcome.

## Where it sits

Step 3 on `bqn`. It assumes FizzBuzz, and leads to
[bowling](bowling.md) and [game of life](game-of-life.md).

## Not available in

`r`, `octave` and `fortran` have [whole-array operations](whole-array-operations.md) and no
way to compose without naming. `haskell` has point-free style as an option and the
community argument about it; here it is the ordinary way to write.

## Source

Written for this repo. Documented at
[BQN: Trains](https://mlochbaum.github.io/BQN/doc/train.html).
