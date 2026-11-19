# The kitchen sink

`kitchen-sink/` is a set of executable, all-passing assertions: a cheatsheet for
JavaScript's toolbox that fails the build if it ever tells you something untrue.

It is not a set of koans. Nothing here starts red and nothing is left blank —
run `make test` and it is green on the first try. Read it, then delete it.

## What is here

| File                              | Covers                                                      |
| --------------------------------- | ----------------------------------------------------------- |
| `kitchen-sink/01_values.test.js`  | constants, missing properties, fallbacks, lists             |
| `kitchen-sink/09_errors.test.js`  | refusing bad input, asserting a failure, custom error types |
| `kitchen-sink/10_gotchas.test.js` | float arithmetic, sorting, loose comparison, `NaN`, `null`  |

Five assertions each, and every one is something you will reach for solving a
kata. Anything that did not clear that bar is not here.

The numbering has gaps because the full set runs `01` to `10`; the rest land as
this template fills out.

## What to do with it

The framing is **"here are the tools you need to solve any of these"** — the
[Made Tech kata list](https://learn.madetech.com/technology/katas/). Pick one
and start:

| Kata           | Leans on                                      |
| -------------- | --------------------------------------------- |
| Bowling        | arithmetic, loop with index, slice            |
| Roman numerals | arithmetic, an ordered table, string building |
| Word Wrap      | split and slice, recursion                    |
| Tennis         | branching on an enum-shaped value             |
| Mars Rover     | modulo, parsing a command string, records     |

## Deleting it

```console
$ rm -r kitchen-sink KITCHEN-SINK.md
$ make test
```

Still green. `make test` runs a bare `node --test`, which walks the tree and
exits `0` when it finds nothing — so removing the suite leaves `src/` and a
project that builds. Nothing else depends on this directory.
