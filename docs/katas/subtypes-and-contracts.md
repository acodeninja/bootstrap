# Percentage, enforced twice

Declare a type that holds 0 to 100 and nothing else. Assign 140 to it from a literal and
find out at compile time; read 140 from a string and find out at run time. Then put a
precondition and a postcondition on a function over it, and break each one on purpose.

## What it teaches

That a range can be part of a type, and that the compiler and the runtime enforce the same
declaration — the literal is rejected before the program exists, and the computed value
raises `Constraint_Error` where it is assigned rather than wherever it is later misused.
That second part is the one worth having: the error names the line that broke the rule.

`Pre` and `Post` extend the same idea to behaviour, and the questions they raise are the
point: what does this function actually require, and what does it promise? Most functions
in most languages never have to answer.

## Where it sits

Step 3 on `ada`. It assumes FizzBuzz, and leads to
[number to LCD](number-to-lcd.md) and [mars rover](mars-rover.md).

## Not available in

`pascal` has subranges and no contracts. `haxe`
[abstracts](abstract-types.md) and `fsharp`
[units](units-of-measure.md) each get part of this. `lean`
[proves it instead](proofs-beside-the-code.md), which is the same ambition with a
different bill. Everywhere else this is a check you remember to write.

## Source

Written for this repo. Documented in
[the Ada Reference Manual, 3.2.2](http://www.ada-auth.org/standards/22rm/html/RM-3-2-2.html)
and under aspect Pre and Post.
