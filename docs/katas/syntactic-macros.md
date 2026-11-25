# The missing control structure

Add `unless` to the language: it takes a condition and a body, and runs the body when the
condition is false. Then add `until`, looping while a condition stays false.

Neither may evaluate anything it was not asked to, which is what rules out writing them as
functions.

## What it teaches

That syntax is a library. A macro receives the unevaluated forms and returns the code to
run in their place, so a control structure is an ordinary thing to write rather than a
privilege the language designer kept. The discipline is in what you expand to: a body
evaluated twice, or a name you introduced colliding with one of the caller's, is the bug
this kata exists to show you.

That last part splits the two rows. Common Lisp macros are unhygienic and you avoid the
collision by hand with a generated symbol; Racket's `syntax-rules` is hygienic and avoids
it for you. Writing the same macro in both is the clearest hour either language offers.

## Where it sits

Step 3 on `commonlisp` and `racket`. It assumes FizzBuzz, and leads to
[test framework](test-framework.md), which is this instinct applied to a real tool.

## Not available in

`scheme` has `syntax-rules` and could share this; it gets
[tail recursion and continuations](tail-recursion-and-continuations.md) instead, because
one Lisp row should be about control rather than syntax. `rust` and `nim` have macros of a
different shape. `forth` reaches the same place by
[defining words](defining-words.md).

## Source

Written for this repo. Documented in
[Practical Common Lisp, chapter 8](https://gigamonkeys.com/book/macros-defining-your-own.html)
and [the Racket guide](https://docs.racket-lang.org/guide/macros.html).
