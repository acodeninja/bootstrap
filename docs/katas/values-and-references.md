# Two inventories

Hold the same inventory twice: once in a `record` and once in a `class`. Assign each to a
second variable, change the copy, and look at the original. Then put the stock codes in a
real `set` and ask what happens to a duplicate.

## What it teaches

The difference between a value and a reference, in a language where both are available and
the syntax for using them is nearly identical. A record assignment copies; a class
assignment shares; and the bug this produces in the wild is the one where somebody
"copied" a list and then changed both. Pascal is a good place to learn it because the two
sit side by side rather than one being the only option.

The set is the second half. Pascal has a set type in the language rather than in a library,
which almost nothing else here does, and it is the right tool for "which of these have we
seen" far more often than people reach for it.

While you are here: `case` is a statement, not an expression, so every arm assigns — and a
string counts from one while a dynamic array counts from zero.

## Where it sits

Step 3 on `pascal`. It assumes FizzBuzz, and leads to
[number to LCD](number-to-lcd.md) and [mars rover](mars-rover.md).

## Not available in

`c`, `cpp`, `csharp`, `swift`, `go` and `rust` all have the value/reference split and spell
it differently. The built-in set type is rarer: `python` and `swift` have one in the
library, and `c`, `lua`, `fortran`, `octave`, `koka` and `ats` have none at all.

## Source

Written for this repo. Documented in
[the Free Pascal reference guide](https://www.freepascal.org/docs-html/ref/ref.html),
under records, classes and set types.
