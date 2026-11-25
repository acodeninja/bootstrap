# Percentage

Make a type that is an `Int` to the runtime and its own type to the compiler: it accepts
0 to 100, refuses anything else at construction, adds to another percentage with `+`, and
cannot be passed to a function expecting a plain `Int` by accident.

No wrapper object, no allocation, no cost at run time.

## What it teaches

`abstract`, which is Haxe doing something few languages do: a distinct type that compiles
away entirely. The safety is real and the representation is unchanged, so this is the cheap
version of the newtype discipline that `rust`, `haskell` and `scala` all reach for with a
wrapper.

It pairs with the other half of Haxe worth knowing: enums carrying payloads, matched by a
`switch` that will not compile with a case missing, and a constructor argument that arrives
from the pattern already typed.

## Where it sits

Step 3 on `haxe`. It assumes FizzBuzz, and leads to
[roman numerals](roman-numerals.md) and [bowling](bowling.md).

## Not available in

`fsharp` goes further with [units of measure](units-of-measure.md). `rust`, `haskell`,
`scala` and `gleam` get the type safety with a wrapper that may or may not be optimised
away. `ada` gets it with a derived type, which is the closest thing in this repo to the
same bargain.

## Source

Written for this repo. Documented at
[Haxe: Abstract types](https://haxe.org/manual/types-abstract.html).
