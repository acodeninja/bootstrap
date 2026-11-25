# Event handler

Events arrive as a union: a click with coordinates, a key press with a key, a scroll with a
delta. Write the handler that describes each one. Then add a fourth kind of event and make
the build fail until the handler covers it.

TypeScript has no exhaustive `match`, so you have to arrange for the failure yourself.

## What it teaches

Discriminated unions and narrowing: a shared literal field is what lets the compiler know
which member you are in, and a `switch` on it narrows the type in each branch so the
payload is available without a cast. Then the trick worth knowing — assigning the
unmatched value to `never` in the default branch, which compiles only while every case is
handled, and so turns a missing case into a type error.

The counterpoint is the other way to be certain and be wrong. A type assertion changes what
the compiler believes and not what is there, so parsed JSON asserted into a shape is a lie
the compiler will help you tell.

## Where it sits

Step 3 on `typescript`. It assumes FizzBuzz, and leads to
[roman numerals](roman-numerals.md) and [mars rover](mars-rover.md).

## Not available in

`javascript` has the same unions and no way to check them, which is why that row does
[closures](closures-that-remember.md) instead. Every row with a real sum type gets this
for free and would find the `never` trick baffling, which is the useful thing to feel.

## Source

Written for this repo. Documented at
[TypeScript: Narrowing](https://www.typescriptlang.org/docs/handbook/2/narrowing.html#exhaustiveness-checking).
