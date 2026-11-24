# {{PROJECT_NAME}}

## Prerequisites

- **Docker**, with the daemon running
- **make** — on Windows, `winget install ezwinports.make`

You do not need a BQN. The toolchain lives in the container, pinned by the
`Dockerfile`, so a green suite here is a green suite anywhere.

## Commands

```console
$ make test    # run the test suite
$ make lint    # compile every file without running it
$ make fmt     # a no-op: BQN has no formatter
$ make build   # a no-op: BQN runs from source
$ make shell   # open a shell in the container
```

## Writing BQN

BQN is written in its own glyph set, and the files are UTF-8. You need a way to
type `⌽`, `∾` and `⊑`: the
[online REPL](https://mlochbaum.github.io/BQN/try.html) has a keyboard, every
editor plugin on
[the BQN site](https://mlochbaum.github.io/BQN/editors.html) maps the backslash
prefix (`\o` is `○`, `\z` is `⌽`), and `.editorconfig` keeps the layout
consistent either way.

[The BQN documentation](https://mlochbaum.github.io/BQN/doc/index.html) is the
reference. The glyph table is
[here](https://mlochbaum.github.io/BQN/help/index.html), one page, every
primitive.

## Tests

Every `.bqn` file under `tests/` is a program that prints
[TAP](https://testanything.org/). Add one and it runs; delete one and nothing
refers to it.

```bqn
⟨Plan, Ok, TapDone⟩ ← •Import "./tester.bqn"
⟨Greet⟩ ← •Import "../src/{{PROJECT_SNAKE}}.bqn"

Plan 1

"a greeting addresses the name it is given" Ok "Hello, world!" ≡ Greet "world"

TapDone @
```

`•Import` resolves a relative path against the directory of the file doing the
importing, not the working directory, which is what lets a test be run on its
own from anywhere.

### The test vocabulary is yours

`tests/tester.bqn` is twelve lines defining `Plan`, `Ok` and `TapDone`. There is
no dependency to add and nothing vendored, because BQN has no test framework at
all and a namespace holding two counters is the whole of one.

`"name" Ok flag` prints one TAP line and counts it. `≡` is the comparison to
reach for: it matches two whole values, arrays included, and answers `1` or `0`.

**The plan line is the safety net.** An error ends a BQN program where it
stands, and `TapDone` — which sets the exit status from the failure count —
never runs. The suite would otherwise look like it simply contained fewer
tests. `Plan` promises a count and the runner fails when the results do not
match it.

## Lint

`make lint` compiles every file under `src/` and `tests/` without running one.
CBQN has no syntax-only flag, but a file wrapped in a function body is compiled
where it appears and called nowhere, so an unknown glyph, a malformed train or
an undefined name is reported and nothing executes. It is a real check: the
suite itself is linted, which a template whose lint *ran* the tests could not
do.

## There is no formatter

No BQN formatter exists. `make fmt` says so and does nothing. There is also
nothing to build: `make build` says the same, because a `.bqn` file is the
program.

## Adding a dependency

BQN's answer is `•Import`, and there is no package manager. A file in `src/` is
reached with `•Import "../src/<name>.bqn"` from a test, or `"./<name>.bqn"` from
another file in `src/`. A file is a namespace: `⇐` exports a name, `←` keeps it
private, and the importer destructures what it wants by name with
`⟨Greet⟩ ← •Import …`.

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
3. [Bowling](https://github.com/acodeninja/bootstrap/blob/main/docs/katas/bowling.md) — index arithmetic, and reading ahead of yourself
4. [Game of Life](https://github.com/acodeninja/bootstrap/blob/main/docs/katas/game-of-life.md) — a grid, and a generation computed from the last one

The rest of the catalogue, and why this language gets these, is in
[docs/katas](https://github.com/acodeninja/bootstrap/tree/main/docs/katas).

Delete this section when the project becomes real work.

## Licence

MIT — see [LICENSE](LICENSE).
