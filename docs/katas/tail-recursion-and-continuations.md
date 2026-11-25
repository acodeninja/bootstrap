# First match, and out

Walk a long list and return the first item satisfying a predicate. Then walk a deeply
nested list and do the same, leaving the walk the moment you find one rather than
unwinding through every level.

There is no loop to break out of and no `return` to reach for.

## What it teaches

Two things, in order. First, that a named `let` in tail position is a loop — the recursion
does not grow the stack, so a million items is fine and the shape you write is the shape
you would have written as a `while`. Second, that leaving early is an ordinary thing a
procedure can be handed: `call/cc` gives you the rest of the computation as a value, and
calling it is how you abandon the walk.

The second half is where readers meet the idea that return is not special. It is the
largest idea in this repo that fits in one evening.

## Where it sits

Step 3 on `scheme`. It assumes FizzBuzz, and leads to
[test framework](test-framework.md).

## Not available in

Nothing else here has first-class continuations. `racket` does and gets
[macros](syntactic-macros.md) instead, so the two Lisp rows differ on purpose. Tail calls
are guaranteed in the Schemes and in `lua`, assumed in the functional rows, and absent in
`python` and `java`.

## Source

Written for this repo. Documented in
[R7RS](https://small.r7rs.org/) under proper tail recursion and `call/cc`.
