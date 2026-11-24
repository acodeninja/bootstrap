# {{PROJECT_NAME}}

## Prerequisites

- **Docker**, with the daemon running
- **make** — on Windows, `winget install ezwinports.make`

You do not need Guile. The toolchain lives in the container, pinned by the
`Dockerfile`, so a green suite here is a green suite anywhere.

## Commands

```console
$ make test    # run the test suite
$ make lint    # compile every file and promote the warnings to failures
$ make fmt     # a no-op: Debian packages no Scheme formatter
$ make build   # compile the project into /cache
$ make shell   # open a shell in the container
```

## Tests

Tests are SRFI-64, which ships inside Guile — `(use-modules (srfi srfi-64))`
needs nothing installed. A suite is a `.scm` file in `tests/` between
`test-begin` and `test-end`; `make test` runs every one of them in sorted order,
each in its own module so two suites can define the same name. Nothing names a
file, so adding one is enough to have it run and deleting one is enough to stop.

`src/` is on `GUILE_LOAD_PATH`, so a suite reaches the project with
`(use-modules ({{PROJECT_SNAKE}}))` rather than a path.

### The exit status is the container's doing

SRFI-64 prints its tally and returns. `test-end` does not exit, so
`guile -s tests/anything.scm` reports failures on stdout and still leaves `$?`
at zero — which would make a test target that cannot fail. The runner in the
image installs a `test-runner-factory`, keeps every runner `test-begin` asks it
for, and exits 1 if any of them finished with an unexpected failure.

That also explains why the suites themselves carry no exit logic: a file that
decided its own status would have to be named by something, and the one promise
this scaffolding makes is that you can delete a test file.

## Compiled output goes to /cache

Guile compiles every file it loads and caches the `.go` under
`$XDG_CACHE_HOME/guile/ccache`, which defaults to `$HOME/.cache`. The image
points both at `/cache`, a named volume, so the first `make test` compiles and
the second reuses — and nothing is written into the project, which is why
`git status` stays clean.

A stray `.go` or a `.log` beside your source means something ran `guile`
directly with the environment unset; both are in `.gitignore`.

## There is no formatter

Debian packages no Scheme formatter, and the usual candidates are not packaged
anywhere you could pin: indentation in a Lisp is a function of what each macro
means, which is why editors ship tables of indent rules instead of a tool you
can run. `.editorconfig` is what keeps the layout honest.

`make lint` therefore checks compilation rather than layout. Guile's compiler
has plenty to say — a variable nothing bound, a call with the wrong number of
arguments, a `format` string that does not match its arguments — and it says all
of it while exiting 0, so `lint` reads the warning port and fails on anything
written to it.

It asks for the warnings by name rather than by level. `-W3` adds
`unused-variable`, which fires once per `test-equal` on SRFI-64's own expansion
and would leave the suite unlintable.

## Adding a dependency

Guile's own module tree is large — SRFI 1 through 171, `(ice-9 ...)`, POSIX,
regular expressions, JSON is the notable absence. Reach for it first.

Beyond that, add the Debian package — they are named `guile-*` — to the
`apt-get install` in the `Dockerfile` and run `docker compose build`. Debian
installs a Guile library onto the default load path, so nothing else needs
saying.

There is deliberately no Guix manifest. It would resolve versions from a
channel fetched at build time, which makes the build depend on the network and
on the day it ran — the opposite of what the pinned image is for.

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

Five katas, in this order, each introducing one thing the last one did not:

1. [Hello, World](https://github.com/acodeninja/bootstrap/blob/main/docs/katas/hello-world.md) — the toolchain, not you
2. [FizzBuzz](https://github.com/acodeninja/bootstrap/blob/main/docs/katas/fizzbuzz.md) — a loop, a branch, and your first test
3. [Word wrap](https://github.com/acodeninja/bootstrap/blob/main/docs/katas/word-wrap.md) — splitting a string, and recursion
4. [Roman numerals](https://github.com/acodeninja/bootstrap/blob/main/docs/katas/roman-numerals.md) — an ordered table, and a string you built
5. [Test framework](https://github.com/acodeninja/bootstrap/blob/main/docs/katas/test-framework.md) — closures, and catching a failure yourself

The rest of the catalogue, and why this language gets these, is in
[docs/katas](https://github.com/acodeninja/bootstrap/tree/main/docs/katas).

Delete this section when the project becomes real work.

## Licence

MIT — see [LICENSE](LICENSE).
