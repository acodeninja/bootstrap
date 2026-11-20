# {{PROJECT_NAME}}

## Prerequisites

- **Docker**, with the daemon running
- **make** — on Windows, `winget install ezwinports.make`

You do not need an interpreter. The toolchain lives in the container, pinned by
the `Dockerfile`, so a green suite here is a green suite anywhere.

## Commands

```console
$ make test    # run the test suite
$ make lint    # a no-op: Bywater BASIC ships no checker
$ make fmt     # a no-op: Bywater BASIC ships no formatter
$ make build   # a no-op: BASIC is interpreted
$ make shell   # open a shell in the container
```

## Tests

A test is a program that prints its results as
[TAP](https://testanything.org). `make test` runs every `tests/*.bas` and fails
on a `not ok`, on an `ERROR in line`, or on a plan that does not match the
number of results.

That last check is the one that matters most here. bwbasic cannot report failure
any other way: a program that fails an assertion exits 0, and so does one that
stops half way through with an error. The plan line is what makes the difference
visible, because the results a dead program never printed are missing from the
count.

Each test declares its plan, then reports through one subroutine:

```basic
10 PRINT "1..1"
50 LET M$ = "a greeting addresses the name it is given"
60 LET P = 0
70 IF GREETING$ = "Hello, world!" THEN LET P = 1
80 GOSUB 8000
```

## Line numbers are the module system

There is no `import`. `MERGE` loads another file's lines into the running
program, so the convention that makes it work is a division of the line numbers:

| Lines         | Hold                                        |
| ------------- | ------------------------------------------- |
| `10`–`7999`   | the program, or the test                    |
| `8000`+       | the test's own reporting subroutines        |
| `9000`+       | subroutines in `src/`, loaded by `MERGE`    |

A subroutine takes its arguments in shared variables, because `GOSUB` has no
parameters: set `WHOM$`, `GOSUB 9100`, read `GREETING$`.

Leave gaps. Numbering in tens is not decoration — it is the only way to insert a
line later without renumbering everything after it.

## There is no linter and no formatter

Nothing is packaged for Bywater BASIC, and the interpreter has no check mode:
it does not even parse a line until the line runs, so a mistake in a branch
nothing took is invisible until something takes it. `make lint` and `make fmt`
therefore say what they are and do nothing.

This is the one template where a green `make lint` proves nothing. The suite is
the whole of your safety, which is an argument for more cases rather than
fewer.

`.editorconfig` is what keeps the layout honest.

## Adding a dependency

BASIC has no package manager. A dependency is a `.bas` file you `MERGE`, so
adding one is adding a file under `src/` with its subroutines numbered from
`9000` up — and the only thing to watch is that two merged files do not claim
the same line numbers.

## CI

`.github/workflows/ci.yml` builds the image and runs lint and tests on every
push, and needs no secrets to do it.

`DOCKERHUB_USERNAME` and `DOCKERHUB_TOKEN` are optional, and worth setting only
if the build starts failing to pull its base image: Docker Hub rate-limits
anonymous pulls and GitHub's runners share IP addresses, so the error looks
nothing like the real cause.

## Licence

MIT — see [LICENSE](LICENSE).
