# Safe divide

Write a divide that answers a sensible result for every input, including a zero divisor
and a value that is text rather than a number. Nothing may be allowed to end the program.

## What it teaches

What programming is like when nothing catches anything. There is no exception, no `Result`,
no status code the library sets — a division by zero ends the run, so the only defence is
a check that happens first. Every refusal in LOLCODE is a guard, and the discipline of
writing them before the operation rather than after is the thing to take away.

The second trap is in the inputs. Arithmetic casts text to a number without being asked
while comparison does not, so a value can divide fine and still fail to equal itself. The
guard has to know which of those it is doing.

## Where it sits

Step 3 on `lolcode`. It assumes [leap years](leap-years.md) — `SMOOSH` is the whole string
library, so FizzBuzz is the longer job.

## Not available in

`befunge`, `intercal`, `basic`, `arm32` and `qsharp` are all in the same position and the
lesson transfers directly. Everywhere else, the language offers somewhere to put the
failure, and this kata is the argument for using it.

## Source

Written for this repo. The language is specified at
[lolcode.org](http://www.lolcode.org/).
