# The signature that changes

Write a function that reads a digit out of a character and fails when the character is not
one. Note what its type says. Now write a second function that calls it and handles the
failure, and note what that one says.

Twenty minutes, and it demonstrates the one thing nothing else in this repo can: the
failure is in the type, and handling it takes the failure back out of the type.

## What it teaches

Effect rows. `exn`, `div` and `console` are not special syntax — they are entries in a row
that is part of every signature, and a function with an empty row is total: it cannot
throw, loop forever, print, or read a reference. A handler is what subtracts an entry.

The lesson lands when you give a function a signature it no longer matches, because its
body gained an effect you did not think of as one. Then push it: write a recursion Koka
cannot see terminating, and watch `div` arrive uninvited.

## Where it sits

Step 3 on `koka`. It assumes FizzBuzz.

## Not available in

Nothing else here puts effects in a type. `haskell` puts them in a monad, which is the
nearest thing and a different idea; every other row lets any function do anything.

## Source

Written for this repo. The template's kitchen sink shows the built-in effects, so defining
a handler of your own is new ground. Documented in
[the Koka book](https://koka-lang.github.io/koka/doc/book.html#sec-handlers).
