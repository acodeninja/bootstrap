# Shape area

A shape is a circle, a rectangle or a triangle. Write the types, write the function that
gives the area, and arrange it so that adding a fourth shape makes the existing function
fail to compile until you handle it.

Then add one more branch that treats a square — a rectangle whose sides are equal —
differently, without adding a type for it.

## What it teaches

That Java has had a sum type since 21, and that getting the compiler to check it depends on
details. A `sealed interface` plus `record` implementations gives you the closed set;
a switch *expression* over it is checked for exhaustiveness, and a switch *statement* is
not — so whether the compiler helps you turns on whether the result is assigned.

Record patterns do the second half: destructuring in the pattern, with a `when` guard, is
how "a rectangle whose sides are equal" becomes a case rather than an `if` inside a case.

## Where it sits

Step 3 on `java`. It assumes FizzBuzz, and leads to
[bowling](bowling.md) and [mars rover](mars-rover.md).

## Not available in

`csharp` has very nearly all of it and only warns on a missing case, which is why that row
does [LINQ](query-over-a-sequence.md) instead. `kotlin`, `scala`, `swift` and the
functional rows have had this for years, and seeing it arrive in Java is a good way to
understand what it is for.

## Source

Written for this repo. Documented at
[JEP 441: Pattern Matching for switch](https://openjdk.org/jeps/441) and
[JEP 440: Record Patterns](https://openjdk.org/jeps/440).
