# {{PROJECT_NAME}}

## Prerequisites

- **Docker**, with the daemon running
- **make** — on Windows, `winget install ezwinports.make`

You do not need an interpreter. `lci` lives in the container, built from a
pinned release in the `Dockerfile`, so a green suite here is a green suite
anywhere.

## Commands

```console
$ make test    # run the test suite
$ make lint    # a no-op: lci has no check mode
$ make fmt     # a no-op: LOLCODE has no formatter
$ make build   # a no-op: LOLCODE is interpreted
$ make shell   # open a shell in the container
```

## Tests

A test prints its results as [TAP](https://testanything.org). `make test` runs
every `tests/*.lol` and fails on a `not ok`, on a non-zero exit from `lci`, or
on a plan that does not match the number of results.

Reporting goes through one function, because a `TROOF` is all an assertion
needs to be:

```lolcode
HOW IZ I report YR num AN YR passed AN YR name
  passed
  O RLY?
    YA RLY
      VISIBLE SMOOSH "ok " AN num AN " - " AN name MKAY
    NO WAI
      VISIBLE SMOOSH "not ok " AN num AN " - " AN name MKAY
  OIC
IF U SAY SO
```

## There is no import, so the runner makes one

`CAN HAS` takes a library name and not a path, and two files on one `lci`
command line are two separate programs. The only way a test can reach `src/` is
to *be* the same program as it.

So `make test` strips the `HAI` and `KTHXBYE` from every file, splices the
bodies together with the modules first, and feeds the result to `lci` through
standard input. Two consequences:

- **Keep the `HAI 1.2` and `KTHXBYE`** in every file. The runner removes them;
  a file without them is not a file it can splice.
- **Everything shares one namespace.** A function in `src/` is visible to every
  test, and so is a variable — there is nothing to qualify a name with.

## There is no linter and no formatter

`lci` has two options, `--help` and `--version`. There is no check mode, so
`make lint` says what it is and does nothing, and this is one of two templates
where a green `make lint` proves nothing.

What does protect you: `lci` parses the whole program before running any of it,
so a syntax error anywhere fails the suite immediately rather than half way
through. And the plan line catches a program that died, because the results it
never printed are missing from the count.

`.editorconfig` is what keeps the layout honest.

## Adding a dependency

LOLCODE has no package manager and `CAN HAS STDIO?` is most of its standard
library. A dependency is a `.lol` file under `src/`, spliced in ahead of the
tests like everything else there.

## CI

`.github/workflows/ci.yml` builds the image and runs lint and tests on every
push, and needs no secrets to do it.

`DOCKERHUB_USERNAME` and `DOCKERHUB_TOKEN` are optional, and worth setting only
if the build starts failing to pull its base image: Docker Hub rate-limits
anonymous pulls and GitHub's runners share IP addresses, so the error looks
nothing like the real cause.

## Licence

MIT — see [LICENSE](LICENSE). `lci` itself is GPL-3 and lives in the image, not
in this project.
