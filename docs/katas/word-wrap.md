# Word wrap

Given a string and a column width, insert line breaks so that no line is longer than the
width, breaking at spaces wherever possible.

It is the smallest kata in the catalogue with real depth. The first two or three cases
are obvious, and then the awkward ones arrive: a word longer than the whole column, a
break that lands exactly on a space, a string that needs no wrapping at all. Each one is
a test you did not think of until it failed.

## What it teaches

Splitting and slicing a string, and recursion — the natural shape is to wrap the first
line and hand the rest back to yourself, which makes it the kata that teaches recursion
to someone who has only ever written loops.

## Where it sits

Step 3 on the Pattern matching, Lisp and Text processing tracks. It assumes FizzBuzz, and
nothing else.

## Not available in

The four rows with no substring: `lolcode` (`SMOOSH` is the whole string library — no
length, no substring, no split), `intercal`, `befunge` and `qsharp`, where a string has
no length and no index (`templates/qsharp/files/tests/kitchen_sink.qs:39`). Also `asp`,
where nothing opens a string.

## Source

- [Made Tech: Word Wrap](https://learn.madetech.com/technology/katas/word-wrap/)
- [Coding Dojo: Word wrap](https://codingdojo.org/kata/WordWrap/)
