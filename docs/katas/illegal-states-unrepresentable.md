# Form state

A sign-up form is being filled in, being submitted, has failed with errors, or has
succeeded. Model it so that "submitting, with validation errors, and also succeeded" cannot
be written down — not caught at run time, not asserted against in a test: unwritable.

Then write the function that describes the current state, and let the compiler tell you
which cases you forgot.

## What it teaches

Designing with a custom type instead of a record of booleans and maybes. Four booleans give
sixteen states, twelve of which are nonsense you then have to defend against; four
constructors give four, and the payload each one carries is exactly what that state needs.
Errors belong to the failure constructor and nowhere else.

Elm is the right place to learn it because there is no escape hatch: no exceptions, no
`try`, no null. `Maybe` and `Result` are the whole story, so modelling badly is felt
immediately rather than patched over.

## Where it sits

Step 3 on `elm`. It assumes FizzBuzz, and leads to
[tennis](tennis.md) and [turnstile](turnstile.md).

## Not available in

The lesson transfers to every row with a sum type — `rust`, `haskell`, `gleam`, `ocaml`,
`swift`, `kotlin`, `scala`, `fsharp`, `dart`, `flix`, `haxe`. It does not transfer to
`go`, `javascript`, `lua`, `c` or `tcl`, where the discipline has to come from you.

## Source

Written for this repo, after Richard Feldmans
[Making Impossible States Impossible](https://www.youtube.com/watch?v=IcgmSRJHu_8).
Documented at [Elm: Custom Types](https://guide.elm-lang.org/types/custom_types.html).
