# Undo

Keep a running tally of words as they arrive, and be able to hand back the tally as it
stood three words ago — without having saved a copy, and without the old tally having been
duplicated.

## What it teaches

That `assoc` returns a new map and leaves the old one alone, and that this is cheap rather
than wasteful. Every version of the tally still exists because every version shares almost
all of its structure with the one before, so keeping history costs nothing and undo is a
variable you already had.

The second lesson is `reduce` with a map as the accumulator, which is the shape most
Clojure data work takes, and the third is laziness: a sequence does no work until
something reads it, so where you thought the work happened is not where it happened.

## Where it sits

Step 3 on `clojure`. It assumes FizzBuzz, and leads to
[word wrap](word-wrap.md).

## Not available in

`elm`, `haskell`, `gleam` and the other functional rows are immutable too and do not make
a feature of sharing. The lesson that does not transfer is the cost: a copied map in
`python` or `go` is a copy, so this pattern is a performance bug there rather than an
idiom.

## Source

Written for this repo. Documented at
[clojure.org: Data Structures](https://clojure.org/reference/data_structures).
