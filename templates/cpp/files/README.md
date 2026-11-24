# {{PROJECT_NAME}}

## Prerequisites

- **Docker**, with the daemon running
- **make** — on Windows, `winget install ezwinports.make`

You do not need a compiler. The toolchain lives in the container, pinned by the
`Dockerfile`, so a green suite here is a green suite anywhere.

## Commands

```console
$ make test    # run the test suite
$ make lint    # check formatting
$ make fmt     # reformat in place
$ make build   # compile the library
$ make shell   # open a shell in the container
```

## Layout

`src/` holds the library, `test/` holds the tests, and `build.mk` holds the
compile rules. `make test` runs inside the container, where globbing works, so
every `test/*.cpp` file is compiled and linked without being named anywhere.
Each `TEST_CASE` registers itself with the runner that `test/main.cpp` defines,
so adding a test file is all adding a test takes.

Objects, the archive and the test binary are written to `/cache` inside the
container, not beside the source, so a second `make test` only recompiles what
you changed and your working tree stays clean.

## Vendored code

`vendor/doctest/` is [doctest](https://github.com/doctest/doctest) 2.5.3, the
test framework, a single header copied in unmodified apart from a provenance
comment at the top. C++ has no standard test framework and no package manager
to fetch one from, so it ships with the project.

doctest is **MIT licensed**, separately from this project's own
[LICENSE](LICENSE), and its copyright stays with its author. `make lint` and
`make fmt` skip `vendor/` deliberately: reformatting someone else's code turns
the next upstream update into a merge conflict.

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
3. [Roman numerals](https://github.com/acodeninja/bootstrap/blob/main/docs/katas/roman-numerals.md) — an ordered table, and a string you built
4. [Number to LCD](https://github.com/acodeninja/bootstrap/blob/main/docs/katas/number-to-lcd.md) — an output assembled across three lines at once
5. [Mars Rover](https://github.com/acodeninja/bootstrap/blob/main/docs/katas/mars-rover.md) — records, enums, parsing, and a failure worth reporting

The rest of the catalogue, and why this language gets these, is in
[docs/katas](https://github.com/acodeninja/bootstrap/tree/main/docs/katas).

Delete this section when the project becomes real work.

## Licence

MIT — see [LICENSE](LICENSE).
