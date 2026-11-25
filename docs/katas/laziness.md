# The first thousand primes

Define the primes. All of them — an infinite list, with no bound anywhere in the
definition. Then take the first thousand.

Then do the same for the Fibonacci numbers, defined in terms of themselves.

## What it teaches

That a value can be defined without being computed, and that this makes some definitions
simpler rather than cleverer. "The primes" is a better thing to write down than "the primes
below n", and laziness is what lets you write the first and ask the second question later.
A list defined in terms of itself is where it stops being an optimisation and becomes a way
of expressing things.

The other half is the bill. Laziness is why a fold can hold a chain of unevaluated work
instead of a number, which is the space leak every Haskell programmer meets once; and why
`length` can succeed over a list whose items would all throw.

## Where it sits

Step 3 on `haskell`. It assumes FizzBuzz, and leads to
[word wrap](word-wrap.md).

## Not available in

Nothing else here is lazy by default. `python` generators, `csharp` and `visualbasic`
iterators, `elixir` streams, `racket` promises and `fsharp` sequences are all laziness you
opt into one value at a time — which is the comparison worth making, because self-reference
is the thing that does not survive the translation.

## Source

Written for this repo. Documented in
[Learn You a Haskell, Starting Out](http://learnyouahaskell.com/starting-out#im-a-list-comprehension).
