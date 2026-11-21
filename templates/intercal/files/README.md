# {{PROJECT_NAME}}

## Prerequisites

- **Docker**, with the daemon running
- **make** — on Windows, `winget install ezwinports.make`

You do not need a compiler. C-INTERCAL lives in the container, pinned by the
`Dockerfile`, so a green suite here is a green suite anywhere.

## Commands

```console
$ make test    # run the test suite
$ make lint    # check syntax and politeness
$ make fmt     # a no-op: INTERCAL has no formatter
$ make build   # compile the project into /cache
$ make shell   # open a shell in the container
```

## Tests

An assertion is an array subscript. `,9` is dimensioned to exactly one element,
and `(100)` indexes it with `1` when two values match and `2` when they do not:

```intercal
(100)	DO .1 <- '?.2$.3'~'#0$#65535'
	PLEASE DO (1020) NEXT
	DO ,9 SUB .1 <- #0
	DO RESUME #1
```

The select-and-mingle expression is `0` exactly when `.2` equals `.3`, syslib's
`(1020)` adds one to it, and a subscript of `2` ends the program with
`ICL241I VARIABLES MAY NOT BE STORED IN WEST HYPERSPACE`. A failing assertion
does not report anything — it stops the program.

So a test sets `.2` and `.3`, calls `(100)`, and then reads out the number of
the assertion it just survived. `READ OUT` writes Roman numerals, which is the
whole of INTERCAL's output, and `make test` pairs those numerals in order with
the `DON'T ok - ` lines in the source to produce
[TAP](https://testanything.org). An assertion that failed has no numeral, so it
and everything after it come back as `not ok`.

```intercal
	DON'T ok - mingle interleaves the bits of two numbers
	DO .2 <- '#1$#1'
	DO .3 <- #3
	PLEASE DO (100) NEXT
	PLEASE READ OUT #7
```

`DON'T` is the only comment the language has: the statement is abstained, so it
never runs and never has to parse.

## Politeness is part of the syntax

Between a fifth and a third of statements must begin with `PLEASE`. Too few and
the compiler answers `ICL079I PROGRAMMER IS INSUFFICIENTLY POLITE`; too many and
it answers `ICL099I PROGRAMMER IS OVERLY POLITE`. Both are refusals to compile,
and `make lint` is how you find out before `make test` does.

The ratio is over the **whole** program, so adding a case can push it out of
range, and so can adding a module — because a module is spliced into the same
program. Keep it near the middle rather than the edges.

## There is no import, so the runner makes one

Two `.i` files handed to `ick` are two separate programs. A test and the
modules it uses have to *be* one program, so `make test` concatenates them —
the test first, because execution starts at the first statement and stops at
its `GIVE UP`, which leaves the modules' subroutines after it, reachable only
by `NEXT`.

Consequences:

- **`src/` holds subroutines, never a `GIVE UP`.** One would end the program
  before the next module's lines.
- **Line labels are global.** `src/` uses `(200)` upwards and the tests use
  `(100)` and `(300)` upwards; syslib owns `(1000)` to `(1999)`.
- **Arguments are shared variables.** `NEXT` takes no parameters, so a
  subroutine reads `.1` and leaves its answer in `.3`.

## `-b`, and why it is not optional

`ick` inserts a chance of `E774 RANDOM COMPILER BUG` into every compile on
purpose. `-b` sets that probability to zero, and every `ick` call here passes
it. Without it this suite failed once at the sixth of fifteen assertions, for
no reason at all.

## Adding a dependency

There is no package manager. A dependency is a `.i` file under `src/` holding
labelled subroutines, spliced in like everything else there. The one thing to
watch is that no two files claim the same label.

## CI

`.github/workflows/ci.yml` builds the image and runs lint and tests on every
push, and needs no secrets to do it.

`.github/workflows/actions.lock` pins the actions that workflow uses to exact
commits, so a tag that moves upstream cannot change what runs. It is
machine-generated: after you add a workflow or edit a `uses:` line, install the
tool once with `gh extension install github/gh-actions-lock` and run
`gh actions-lock` to rebuild it. Turning on Dependabot for `github-actions`
keeps the workflow and the lockfile in step without that.

`DOCKERHUB_USERNAME` and `DOCKERHUB_TOKEN` are optional, and worth setting only
if the build starts failing to pull its base image: Docker Hub rate-limits
anonymous pulls and GitHub's runners share IP addresses, so the error looks
nothing like the real cause.

## Licence

MIT — see [LICENSE](LICENSE).
