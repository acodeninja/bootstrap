# {{PROJECT_NAME}}

## Prerequisites

- **Docker**, with the daemon running
- **make** — on Windows, `winget install ezwinports.make`

You do not need clingo. The toolchain lives in the container, pinned by the
`Dockerfile`, so a green suite here is a green suite anywhere.

## Commands

```console
$ make test    # run the test suite
$ make lint    # ground every file, warnings included
$ make fmt     # a no-op: ASP has no formatter
$ make build   # ground the sources into /cache
$ make shell   # open a shell in the container
```

## Tests

A test is not a call and it asserts nothing by comparing values. It is an ASP
program in `tests/`, and every expectation is an integrity constraint that
throws away each answer set where the expectation does not hold:

```prolog
:- not reaches(a, c).
```

If `reaches(a, c)` holds, the constraint is satisfied and the program has an
answer set. If it does not, the constraint removes every candidate and the
program has none at all — clingo reports `UNSATISFIABLE`, and that is the
failure. There is no assertion library because the solver already does this.

`make test` reads clingo's exit status, which is not a 0/1 convention:

| Status | Means                                                  |
| ------ | ------------------------------------------------------ |
| `30`   | satisfiable, every model found — a program of facts    |
| `10`   | satisfiable, search stopped early — a choice rule      |
| `20`   | unsatisfiable: a constraint fired, so the test failed  |
| `65`   | clingo refused the file: syntax, or an unsafe variable |

Files are found by glob, so a new `tests/*.lp` needs no registration and
deleting one takes its tests with it. Tests reach the project's own rules with
`#include "../src/{{PROJECT_SNAKE}}.lp".`, whose path is relative to the file
doing the including.

The cost of this design is that a failure names the file and not the
constraint: an unsatisfiable program has no answer set, so there is nothing for
clingo to print. Comment constraints out until it goes green, and the last one
you touched is the one that failed.

## Grounding and solving

The two phases are separate programs, and `make build` is the first of them.
`gringo` turns the rules into a variable-free program — one ground rule per
combination of values a variable can take — and writes it to
`/cache/build/*.aspif`, which any ASP solver reads. `clingo` is both phases in
one process, which is what `make test` uses.

This is also where the surprises live. Grounding is where an unsafe variable is
refused, and where a rule over four variables and a hundred constants becomes a
hundred million rules. `make lint` runs the same phase with `--warn=all` and
discards the output, so it is the only static check the language has.

## There is no formatter

Nothing formats ASP. Potassco publishes no tool, and no third-party one is
packaged, so `make fmt` prints a line saying so and changes nothing. The target
exists because every project here has the same six, not because there is work
for it to do. `.editorconfig` carries the indentation instead.

## Adding a dependency

ASP has no package manager and nothing to import. A program is the files you
hand clingo, and the way to reuse one is `#include "path.lp".` — so a library
is a file you copy in.

`@`-terms call out of the program to a scripting language, which is where the
kitchen sink's string join comes from. This image is built **with Lua 5.4 and
without Python**; `clingo --version` says so. A `#script (python)` block will
not run here.

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

## Course

Four katas, in this order, each introducing one thing the last one did not:

1. [Hello, World](https://github.com/acodeninja/bootstrap/blob/main/docs/katas/hello-world.md) — the toolchain, not you
2. [FizzBuzz](https://github.com/acodeninja/bootstrap/blob/main/docs/katas/fizzbuzz.md) — a loop, a branch, and your first test
3. [Turnstile](https://github.com/acodeninja/bootstrap/blob/main/docs/katas/turnstile.md) — a state machine, and a transition that carries an action
4. [Eight queens](https://github.com/acodeninja/bootstrap/blob/main/docs/katas/eight-queens.md) — constraints as a description rather than a procedure

The rest of the catalogue, and why this language gets these, is in
[docs/katas](https://github.com/acodeninja/bootstrap/tree/main/docs/katas).

Delete this section when the project becomes real work.

## Licence

MIT — see [LICENSE](LICENSE).
