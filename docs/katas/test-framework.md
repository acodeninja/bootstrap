# Test framework

Write the test framework. Tests have names, they run one at a time, one assertion each,
and a failing one reports itself and does not stop the others. Then make it extensible, so
somebody else can hook new behaviour into it without editing it.

The bootstrap problem is the interesting part: you are test-driving the thing that runs
tests. Use the language's own runner to drive yours and the two coexist awkwardly; bootstrap
with your own and you have to trust it before it works.

## What it teaches

Closures and higher-order functions — registering a test is handing a function to a
collection and calling it later — and catching a failure, which is the one thing the
framework cannot delegate to anybody else.

## Where it sits

The last step of the Lisp track and of the `smalltalk` course. It assumes Roman numerals,
and more importantly it assumes you have used the language's own runner enough to have an
opinion about it.

## Not available in

Two separate walls, and a row needs to clear both:

- **No first-class functions** — `befunge` (none, and no way to invent one), `lolcode` (a
  function cannot be handed anywhere), `basic` (`DEF FN` will not nest and `GOSUB` takes no
  arguments), `intercal`, `asp`.
- **Nothing catches a failure** — `qsharp` (no try, no catch, no Result), `arm32`, and the
  four above.

`forth` is the surprise: it has execution tokens and `CATCH`/`THROW`, so despite sitting
on the Constrained track it is one of the better languages here for this. `sql` is the
other, and the proof is in the template: PL/pgSQL has `RAISE` and `EXCEPTION WHEN`, a
function name can be held as a `regprocedure` and called through `EXECUTE`, and pgTAP —
which the suite is written in — is a test framework written in exactly that.

## Source

- [Made Tech: Test Framework](https://learn.madetech.com/technology/katas/test-framework/)
- [Destroy All Software: building RSpec from scratch](https://www.destroyallsoftware.com/screencasts/catalog/building-rspec-from-scratch)
  — cited by that page, and a solution, so leave it until afterwards
