# {{PROJECT_NAME}}

## Prerequisites

- **Docker**, with the daemon running
- **make** — on Windows, `winget install ezwinports.make`

You do not need GnuCOBOL. The toolchain lives in the container, pinned by the
`Dockerfile`, so a green suite here is a green suite anywhere.

## Commands

```console
$ make test    # run the test suite
$ make lint    # check every program compiles, warnings included
$ make fmt     # a no-op: GnuCOBOL ships no formatter
$ make build   # compile the project into /cache
$ make shell   # open a shell in the container
```

## Tests

A test is a program. It exercises the code, reports each result as a line of
[TAP](https://testanything.org), and sets `RETURN-CODE` to the number of
failures so its exit status is right on its own.

`make test` compiles every `tests/*.cbl` against every module in `src/`, runs
it, and fails on a `not ok`, on a plan that does not match the number of
results, or on a non-zero exit. Add a program to `tests/` and it is picked up;
delete one and nothing refers to it.

Each program declares its plan up front and reports through two paragraphs:

```cobol
DISPLAY "1..1"

MOVE "a greeting addresses the name it is given" TO WS-TEST-NAME
IF FUNCTION TRIM(WS-GREETING) = "Hello, world!"
    PERFORM REPORT-PASS
ELSE
    PERFORM REPORT-FAIL
END-IF
```

**There is no unit-test framework**, and that is not an oversight. The two that
exist are a GPL-2 copybook that would compile into your own program and take its
licence with it, and an archived project whose last release was 2021 and which
needs a JVM. A driver program that sets `RETURN-CODE` is how COBOL has always
tested COBOL; TAP only adds a readable line per case.

GnuCOBOL's runtime prints `Warning: program compiled against libxml 212` on
startup. It comes from Debian's packaging, goes to stderr, and means nothing
here.

## Source format

Every file starts with `>>SOURCE FORMAT IS FREE`, so code is not confined to
columns 8 through 72. Fixed format is the older convention and still the
default; a test name long enough to be a sentence does not fit inside it
without continuation lines.

## There is no formatter

Nothing is packaged for COBOL, so `make fmt` says so and does nothing.
`make lint` compiles every program with `-Wall` and `-fsyntax-only` instead,
which catches the things that matter: a literal too large for its target, a
condition that is always true, a paragraph nothing performs.

`.editorconfig` is what keeps the layout honest.

## Adding a dependency

COBOL has no package manager. A module is a `.cbl` file in `src/`, and
`make test` compiles all of them, so adding a program is adding a file.

To call one from another, give it a `PROCEDURE DIVISION USING` and `CALL` it by
its `PROGRAM-ID` — `src/{{PROJECT_SLUG}}.cbl` and `tests/greet.cbl` are that
pair already.

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
3. [Leap years](https://github.com/acodeninja/bootstrap/blob/main/docs/katas/leap-years.md) — arithmetic and branching, no strings needed
4. [Roman numerals](https://github.com/acodeninja/bootstrap/blob/main/docs/katas/roman-numerals.md) — an ordered table, and a string you built
5. [Bowling](https://github.com/acodeninja/bootstrap/blob/main/docs/katas/bowling.md) — index arithmetic, and reading ahead of yourself

The rest of the catalogue, and why this language gets these, is in
[docs/katas](https://github.com/acodeninja/bootstrap/tree/main/docs/katas).

Delete this section when the project becomes real work.

## Licence

MIT — see [LICENSE](LICENSE).
