# {{PROJECT_NAME}}

## Prerequisites

- **Docker**, with the daemon running
- **make** — on Windows, `winget install ezwinports.make`

You do not need gforth. The toolchain lives in the container, pinned by the
`Dockerfile`, so a green suite here is a green suite anywhere.

## Commands

```console
$ make test    # run the test suite
$ make lint    # compile every word, which is the whole check
$ make fmt     # a no-op: Forth has no formatter
$ make build   # a no-op: Forth runs from source
$ make shell   # open a shell in the container
```

## Tests

Every `.fs` file under `tests/` is a program that prints
[TAP](https://testanything.org/). Add one and it runs; delete one and nothing
refers to it.

```forth
require ./tester.fs
require ../src/{{PROJECT_SNAKE}}.fs

1 plan

T{ s" world" greet s" Hello, world!" compare -> 0 }T a greeting addresses the name it is given

tap-done
```

`require ./` and `require ../` resolve against the directory of the file doing
the requiring, not the working directory, which is what lets a test be run on
its own from anywhere.

### The test vocabulary is yours

`tests/tester.fs` is twenty lines defining `T{`, `->` and `}T`. There is no
dependency to add and nothing vendored, because defining the words you want is
what Forth is for — and `T{ ... -> ... }T` is the shape the Forth 2012 test
suite uses, so it is already familiar.

`T{` remembers the stack depth, the code runs, `->` stashes whatever it left,
and `}T` compares that against the values after the arrow and prints one TAP
line. The name is the rest of the line.

**The plan line is the safety net.** A word that underflows the stack stops
where it stands, and the suite would otherwise look like it simply ran fewer
tests. `plan` promises a count and the runner fails when the results do not
match it.

## Lint

`make lint` compiles `src/` and the test vocabulary. In Forth that is a real
check: an undefined word is an error at compile time, so a typo cannot reach a
test run. The test bodies are deliberately not linted, because `require`-ing a
test *runs* it, and running them is `make test`'s job.

## There is no formatter

No Forth formatter exists. `make fmt` says so and does nothing, and
`.editorconfig` is what keeps the layout consistent.

## Adding a dependency

Forth's answer is `require`, and there is no package manager. A file in `src/`
is reached with `require ../src/<name>.fs` from a test, or `require ./<name>.fs`
from another file in `src/`. Everything a required file defines is visible
everywhere afterwards: there is one namespace, and that is the whole module
system.

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

Three katas, in this order, each introducing one thing the last one did not:

1. [Hello, World](https://github.com/acodeninja/bootstrap/blob/main/docs/katas/hello-world.md) — the toolchain, not you, and already solved beside this file
2. [FizzBuzz](https://github.com/acodeninja/bootstrap/blob/main/docs/katas/fizzbuzz.md) — a loop, a branch, and your first test
3. [Counter words](https://github.com/acodeninja/bootstrap/blob/main/docs/katas/defining-words.md) — words that define words

Then, when the group wants more: [Leap years](https://github.com/acodeninja/bootstrap/blob/main/docs/katas/leap-years.md) → [RPN calculator](https://github.com/acodeninja/bootstrap/blob/main/docs/katas/rpn-calculator.md).

The rest of the catalogue, and why this language gets these, is in
[docs/katas](https://github.com/acodeninja/bootstrap/tree/main/docs/katas).

Delete this section when the project becomes real work.

## Licence

MIT — see [LICENSE](LICENSE).
