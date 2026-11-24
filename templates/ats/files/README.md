# {{PROJECT_NAME}}

## Prerequisites

- **Docker**, with the daemon running
- **make** — on Windows, `winget install ezwinports.make`

You do not need ATS2. The toolchain lives in the container, pinned by the
`Dockerfile`, so a green suite here is a green suite anywhere.

## Commands

```console
$ make test    # run the test suite
$ make lint    # typecheck every source and test file
$ make fmt     # a no-op: ATS2 ships no formatter
$ make build   # compile the project into /cache
$ make shell   # open a shell in the container
```

## Tests

A test is a program that prints [TAP](https://testanything.org): a plan line,
then one `ok` or `not ok` per assertion. ATS has no test framework, so
`tests/tap.hats` defines the plan and the result lines in about twenty lines
of ATS, and the image compares what a program planned against what it
reported — which is what tells a failed assertion from a program that stopped
part way through.

`make test` compiles every `tests/*.dats` against every `src/*.dats` and runs
it. Nothing names a test file, so adding one is enough to have it run and
deleting one is enough to stop. `tests/tap.hats` is an include rather than a
`.dats` precisely so the glob does not take it for a test of its own.

Binaries and the C that `patsopt` generates land in `/cache/build`, which is a
named volume: the project directory stays clean, and a second `make test` with
nothing edited reuses the binaries rather than recompiling them.

## Linear types, and what they cost you

ATS runs with no garbage collector and no reference counting:
`-DATS_MEMALLOC_LIBC` picks plain `malloc`. What keeps that honest is the type
system rather than a runtime — a *linear* value has to be consumed exactly
once, and the typechecker refuses the program if it is dropped or used twice.

```console
$ make lint
/work/src/{{PROJECT_SNAKE}}.dats: error(3): the linear dynamic variable
[message] needs to be consumed but it is preserved with the type
[S2Eapp(S2Ecst(strptr_addr_vtype); S2EVar(5282))] instead.
```

So `greet` answers with a `Strptr1` and not a `string`, and the caller frees
it. A `string` literal is shared and costs nothing; anything built at run time
belongs to somebody.

Be ready for this to be slow going. The error messages are printed in terms of
the compiler's internal syntax — `S2Eapp(S2Ecst(...))` and all — and the
constraint solver reports what it could not discharge rather than what you
should have written. The prelude is large, sparsely documented and reached
through `#include "share/atspre_staload.hats"`; reading
`/usr/lib/ats2-postiats-0.4.2/prelude/SATS/*.sats` inside `make shell` is
usually faster than searching for prose. `tests/kitchen_sink.dats` is fifteen
worked answers to the questions that come up first.

## There is no formatter

Nothing formats ATS. The compiler package ships `patscc`, `patsopt` and
`myatscc` and no formatter, and there is no third-party one to install.
`make fmt` says so and exits 0 rather than pretending a check was made.

`make lint` is therefore `patsopt --typecheck`, which is a real check and a
thorough one: types, linearity, exhaustiveness of every `case+`, and the
arithmetic constraints behind every array index. `.editorconfig` is what keeps
the layout honest.

## Adding a dependency

ATS2 has no package manager. What ships with the compiler is the prelude plus
`libats`, which covers lists, arrays, maps, hash tables and string buffers —
`staload "libats/SATS/..."` needs nothing added.

C is the escape hatch, and the intended one: `%{ ... %}` embeds C directly, and
`$extfcall` and `extern fun ... = "mac#"` give an ATS signature to something
already compiled. Install the library's Debian package in the `Dockerfile`, add
`-l<name>` to the `patscc` lines in the same file — the compile commands live
in the image, not here — and run `docker compose build`.

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
3. [Leap years](https://github.com/acodeninja/bootstrap/blob/main/docs/katas/leap-years.md) — arithmetic and branching, no strings needed
4. [Roman numerals](https://github.com/acodeninja/bootstrap/blob/main/docs/katas/roman-numerals.md) — an ordered table, and a string you built

The rest of the catalogue, and why this language gets these, is in
[docs/katas](https://github.com/acodeninja/bootstrap/tree/main/docs/katas).

Delete this section when the project becomes real work.

## Licence

MIT — see [LICENSE](LICENSE).
