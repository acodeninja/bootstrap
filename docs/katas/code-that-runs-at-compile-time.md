# The baked table

Build a lookup table from each digit to its name in English, and have the table exist
before the program starts rather than be assembled when it runs. Then assert, also before
the program starts, that it holds exactly ten entries.

The table is trivial. Making the compiler build it, and making a wrong table a build
failure rather than a test failure, is not.

## What it teaches

That the compiler will run your code if you ask it to, and that "constant" and "computed"
are not opposites. Three spellings of one idea, one per language: Zig has `comptime`, D
has compile-time function execution with `static assert`, and Nim has `static:` blocks
and `const` that calls ordinary procedures.

The shift worth having is in where errors live. A table built at startup is checked by a
test; a table built at compile time is checked by the build, and so cannot be wrong in a
binary that exists.

## Where it sits

Step 3 on `zig`, `d` and `nim`. It assumes FizzBuzz.

## Not available in

Most rows here have no compile time to speak of. `rust` has `const fn`, `cpp` has
`constexpr`, `lean` and `ats` evaluate while typechecking — the same idea through a
narrower door each time, and worth a look once this is done.

## Source

Written for this repo. Zig's own kitchen sink never mentions `comptime`, so for that row
this is new ground. Documented at
[Zig](https://ziglang.org/documentation/master/#comptime),
[D](https://dlang.org/spec/function.html#interpretation) and
[Nim](https://nim-lang.org/docs/manual.html#statements-and-expressions-static-statement-slash-expression).
