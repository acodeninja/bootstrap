# Sliding window

Yield every window of n consecutive items from a sequence, without ever holding more than
n of them at once. Then make it work on a sequence that never ends, and take the first
five windows from it.

Then do it again with `itertools` and see how little of it you needed to write.

## What it teaches

That a function can be paused. `yield` turns a function into something that produces values
on demand, keeps its own local state between them, and never builds the list — which is
what makes the infinite case possible rather than merely tidy.

The second clause is where generators stop being an optimisation. You cannot return a list
you have not finished computing; you can yield from one. That is a different capability,
not a faster version of the same one.

The trap is that a generator is consumed once. Walking it twice gives you nothing the
second time, silently, which is the single most common way this feature goes wrong.

## Where it sits

Step 3 on `python`. It assumes FizzBuzz, and leads to
[roman numerals](roman-numerals.md) and [bowling](bowling.md), which wants exactly this
lookahead.

## Not available in

`haskell` is [lazy by default](laziness.md) and needs no keyword. `csharp`,
`visualbasic`, `javascript`, `ruby` and `lua` all have a version of this;
`c`, `go` before 1.23, `fortran` and `pascal` have none, and the comparison is the point.

## Source

Written for this repo. Documented at
[Python: Generators](https://docs.python.org/3/tutorial/classes.html#generators).
