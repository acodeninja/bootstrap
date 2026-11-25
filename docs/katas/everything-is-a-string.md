# Repeat until

Tcl has no `repeat ... until`. Add one, so that `repeat { ... } until { ... }` runs the body
at least once and then keeps going while the condition is false. It must see and set the
caller's variables, exactly as a built-in would.

## What it teaches

That there is no syntax, only commands, and that a command of yours is indistinguishable
from one that shipped. The body arrives as a string; `uplevel` runs it in the caller's
frame, which is what makes the caller's variables visible; and `expr` evaluates the
condition. Nothing about the result is second-class.

The deeper lesson is the one in the title. A list is its own text, a script is a string, a
procedure body is a string — so code and data are not merely interchangeable in principle,
they are the same type. Once that lands, `uplevel`, `eval` and `{*}` stop looking like
escape hatches.

Mind where a comment is legal while you do it: `#` only begins a comment where a command
could begin, which catches everybody once.

## Where it sits

Step 3 on `tcl`. It assumes FizzBuzz, and leads to
[word wrap](word-wrap.md) and [string calculator](string-calculator.md).

## Not available in

The lisps add control structures with [macros](syntactic-macros.md) over an AST, and
`forth` with [defining words](defining-words.md) over a dictionary — three mechanisms for
one ambition. Nothing else here lets a procedure reach into its caller's scope on purpose.

## Source

Written for this repo. Documented at
[uplevel](https://www.tcl.tk/man/tcl8.6/TclCmd/uplevel.htm).
