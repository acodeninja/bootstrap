# each_slice, by hand

Write a method that takes a collection and a size and yields each chunk of that size to a
block. Then make it return an enumerator when no block is given, so it chains. Then get
Enumerable to do the rest of the work for you by including it in a class of your own.

## What it teaches

That a block is a parameter every method has whether it declares one or not, and that
`yield` is how you reach it. Returning an enumerator when there is no block is the
convention that makes Ruby collections chain, and writing it once is how the whole library
stops looking like magic.

The second half is the better trade: define `each` in your own class, include Enumerable,
and get `map`, `select`, `sort_by`, `each_cons` and forty more for free. One method for
forty is the best bargain in the language.

## Where it sits

Step 3 on `ruby`. It assumes FizzBuzz, and leads to
[roman numerals](roman-numerals.md) and [bowling](bowling.md).

## Not available in

`smalltalk` has blocks as objects and
[a whole kata about it](messages-not-calls.md). `python` has
[generators](generators.md), which answer the same question from the other end — the
caller drives rather than the callee pushing. `javascript`, `groovy` and `kotlin` pass
functions and have no implicit block parameter.

## Source

Written for this repo. Documented at
[Ruby: Enumerable](https://docs.ruby-lang.org/en/master/Enumerable.html).
