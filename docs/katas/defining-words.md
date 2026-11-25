# Counter words

Write a word that makes counters. `counter tally` should define a new word `tally`, with a
cell of storage of its own, which bumps and reports its count when you run it.

Then write one more: a word that defines constants, so `42 named answer` makes `answer`
push 42.

## What it teaches

That the compiler is a word like any other, and that defining your own defining words is
the ordinary way to work rather than a trick. `create` makes a header, `allot` claims the
storage behind it, and `does>` says what the new word does when it runs — which is the
first time most readers see compile time and run time in one definition.

This is the reason Forth is in this repo. Every other row hands you a fixed set of
declaration forms; here the set is yours to extend, and a stack-effect comment is how you
keep track.

## Where it sits

Step 3 on `forth`. It assumes FizzBuzz, and pairs with
[RPN calculator](rpn-calculator.md), which is the follow-on.

## Not available in

The lisps come closest — [syntactic macros](syntactic-macros.md) is the same instinct
with a reader and an AST instead of a dictionary. Nothing else here lets you add a
declaration form at all.

## Source

Written for this repo. Documented in
[Starting Forth, chapter 11](https://www.forth.com/starting-forth/11-forth-compiler-defining-words/).
