# Run length

Compress a list into runs: `[a, a, b, a, a, a]` becomes `[(2, a), (1, b), (3, a)]`. Then
expand it again.

Gleam has no `for`, no `while` and no `until`. Not "they are discouraged" — the syntax does
not exist.

## What it teaches

That a loop is a function, and that writing one deliberately is the way to learn where the
accumulator goes. Both halves of this kata need state carried across steps, which is the
case a `map` cannot cover and a fold can — so it is also the kata that makes `fold` make
sense rather than seem like a party trick.

The second lesson is the compiler. Every `case` must cover every variant, so a
half-finished recursion does not compile rather than failing on the input you forgot, and
`Result` is the only failure channel there is.

## Where it sits

Step 3 on `gleam`. It assumes FizzBuzz, and leads to
[word wrap](word-wrap.md), which wants the same shape over text.

## Not available in

`haskell` and `elm` are in the same position and the lesson transfers whole. Everywhere
else a loop is available, which is why this is worth doing in the row that cannot reach
for one.

## Source

Written for this repo. Documented at
[Gleam: Recursion](https://tour.gleam.run/functions/recursion/).
