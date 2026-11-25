# Rate limiter

Write something that answers yes to the first three calls in a row and no after that, and
that nobody can reset or inspect from outside. Then write a second one and show the two
counts are independent.

Then make it general: a function that takes a limit and hands back a limiter.

## What it teaches

That a function can keep state, and that the state is private because of scope rather than
because of a keyword. The variable lives in the enclosing call and outlives it, which is
the whole mechanism — and the second clause of the problem is what proves each closure got
its own, rather than sharing one.

The classic trap belongs here too: a closure made inside a loop captures the variable, not
its value at the time, so a list of closures built that way all agree. Both languages let
you make that mistake, and both have the spelling that avoids it.

Groovy adds the thing closures grow into. A closure with a delegate is how a builder reads
like syntax, which is most of what Groovy is used for.

## Where it sits

Step 3 on `javascript` and `groovy`. It assumes FizzBuzz, and leads to
[roman numerals](roman-numerals.md) and [test framework](test-framework.md), which is
closures doing real work.

## Not available in

Nearly everything here has closures, and the two rows that do not —
`befunge` and `lolcode` — are why
[test framework](test-framework.md) is unavailable to them. The privacy-by-scope part does
not transfer to `go`, whose loop variable capture changed in 1.22 and is worth comparing.

## Source

Written for this repo. Documented at
[MDN: Closures](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Guide/Closures) and
[Groovy: Closures](https://groovy-lang.org/closures.html).
