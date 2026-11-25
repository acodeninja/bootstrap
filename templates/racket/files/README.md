# {{PROJECT_NAME}}

## Prerequisites

- **Docker**, with the daemon running
- **make** — on Windows, `winget install ezwinports.make`

You do not need Racket. The toolchain lives in the container, pinned by the
`Dockerfile`, so a green suite here is a green suite anywhere.

## Commands

```console
$ make test    # run the test suite
$ make lint    # expand every module, which is the whole check
$ make fmt     # a no-op: Racket has no pinnable formatter
$ make build   # compile every module to bytecode
$ make shell   # open a shell in the container
```

## Tests

`make test` is `raco test -y tests/`, which walks the directory and runs the
`test` submodule of every `.rkt` file it finds, caching the bytecode as it goes.
Add a file there and it runs; delete one and nothing refers to it.

```racket
#lang racket/base

(module+ test
  (require rackunit
           "../src/{{PROJECT_SLUG}}.rkt")

  (test-case "a greeting addresses the name it is given"
    (define greeting (greet "world"))

    (check-equal? greeting "Hello, world!")))
```

**The `(module+ test ...)` wrapper is where the checks go.** `raco test` runs a
file's `test` submodule, and runs a file without one as a plain program
instead — which works, but means a module of definitions is loaded and found to
assert nothing. The submodule is what says the file is a test.

A project module is required by relative path, as a string, so a project named
after a Racket keyword still works: nothing here turns `{{PROJECT_SLUG}}` into
an identifier.

## Lint

`make lint` macro-expands every module under `src/` and `tests/` and throws the
expansion away. Racket resolves identifiers at expansion time, so a typo, a
missing `require` or a misspelled export fails the target.

`raco make` would catch the same things and is deliberately not what `lint`
runs: it reports every file already up to date on a second run, so the second
run checks nothing. That belongs in `make build`, where caching is the point.

## Compiled output goes to the cache volume

Racket writes bytecode to a `compiled/` directory beside each source file, which
in a bind mount would leave a modified project after every run. The image sets
`PLTCOMPILEDROOTS=/cache/zo:` so it lands in a named volume instead, and `git
status` stays clean. The first `make test` compiles; the second reuses.

That bytecode is also architecture-specific — Racket CS compiles to machine code
and refuses a file built for another machine type outright, rather than falling
back to the source. Keeping it out of the project is what stops that mattering.
`docker compose down -v` clears it if it ever needs clearing.

## There is no formatter

Racket's formatter is `raco fmt`, from the third-party `fmt` package. It is not
in Debian, and upstream publishes no version tags, so installing it would mean
an unpinned `raco pkg install` resolving a different version on every build —
the one thing the pinned image exists to prevent. `make fmt` says so and does
nothing, and `.editorconfig` is what keeps the layout consistent.

## Adding a dependency

Racket's package manager is `raco pkg`, and this project deliberately does not
call it at build time: a package without a version tag resolves to whatever the
catalogue serves that day. Add the Debian package where one exists — they are
named `racket-*` — to the `apt-get install` in the `Dockerfile` and run
`docker compose build`. Where one does not, `raco pkg install --no-setup` with
a commit-pinned Git source in the `Dockerfile` keeps the build reproducible.

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
3. [The missing control structure](https://github.com/acodeninja/bootstrap/blob/main/docs/katas/syntactic-macros.md) — syntax as a library

Then, when the group wants more: [Word wrap](https://github.com/acodeninja/bootstrap/blob/main/docs/katas/word-wrap.md) → [Roman numerals](https://github.com/acodeninja/bootstrap/blob/main/docs/katas/roman-numerals.md) → [Test framework](https://github.com/acodeninja/bootstrap/blob/main/docs/katas/test-framework.md).

The rest of the catalogue, and why this language gets these, is in
[docs/katas](https://github.com/acodeninja/bootstrap/tree/main/docs/katas).

Delete this section when the project becomes real work.

## Licence

MIT — see [LICENSE](LICENSE).
