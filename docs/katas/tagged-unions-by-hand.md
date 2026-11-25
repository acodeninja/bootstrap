# Cell

A spreadsheet cell holds one of three things: a number, a piece of text, or an error. Write
the type, write a function that describes whatever a cell holds, and write a second that
adds two cells — refusing, in whatever way C refuses, when either is not a number.

## What it teaches

How much machinery a sum type costs when the language has none. An `enum` for the tag, a
`union` for the payload, a `struct` to hold both, and a `switch` whose completeness is
yours to keep — the compiler will not tell you a case is missing, and the amount of code
this takes *is* the lesson.

The second half teaches the refusal idiom: a return code with the answer written through a
pointer, and `errno` set only by a call that actually failed. There are no exceptions to
reach for and no `Result` to return.

## Where it sits

Step 3 on `c`. It assumes FizzBuzz.

## Not available in

`cpp` does this with `std::variant` and a visit the compiler checks, which is
[its own step 3](visiting-a-variant.md) and the clearest demonstration of why the two are
separate templates. `objc`, `go`, `fortran`, `octave` and `pascal` are all in C's position
and solve it the same way.

## Source

Written for this repo. The feature is the absence of a feature, which no catalogue kata
would think to exercise.
