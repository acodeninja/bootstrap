# Count or list

Write one subroutine that returns the words of a sentence, and have it answer the words
when the caller wants a list and the number of words when the caller wants a single value.
One subroutine, no flag argument, no second function.

Then call it in a way that gives you the answer you did not expect, and work out why.

## What it teaches

Context: the caller decides what shape the answer has, and the callee can ask which it is.
This is the thing about Perl that no other language in this repo does, and it explains most
of the surprises people report — an array in scalar context is its own length, a list
assignment takes the first element, and `wantarray` is how a subroutine finds out which
world it is in.

Once seen it is not confusing, and the regular-expression half of the language depends on
it: a match in list context gives you the captures and in scalar context gives you whether
it matched.

## Where it sits

Step 3 on `perl`. It assumes FizzBuzz, and leads to
[word wrap](word-wrap.md) and [string calculator](string-calculator.md).

## Not available in

`raku` dropped it deliberately, which makes those two rows the best available before-and-
after. Nothing else here has it, and the languages that return a tuple instead —
`go`, `python`, `lua` — make the caller unpack rather than letting the caller choose.

## Source

Written for this repo. Documented at
[perldata: Context](https://perldoc.perl.org/perldata#Context).
