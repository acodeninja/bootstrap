# {{PROJECT_NAME}}

## Prerequisites

- **Docker**, with the daemon running
- **make** — on Windows, `winget install ezwinports.make`

You do not need Tcl. The toolchain lives in the container, pinned by the
`Dockerfile`, so a green suite here is a green suite anywhere.

## Commands

```console
$ make test    # run the test suite
$ make lint    # byte-compile every file and report the parse errors
$ make fmt     # a no-op: Tcl has no formatter
$ make build   # a no-op: Tcl runs from source
$ make shell   # open a shell in the container
```

## Tests

[tcltest](https://www.tcl-lang.org/man/tcl8.6/TclCmd/tcltest.htm) ships with
Tcl, so there is nothing to install. Every `*.test` file under `tests/` is
found and run; add one and it runs, delete one and nothing refers to it.

```tcl
package require tcltest
namespace import ::tcltest::*

source [file join [file dirname [info script]] .. src {{PROJECT_SNAKE}}.tcl]

test greet-1 {a greeting addresses the name it is given} -body {
    {{PROJECT_SNAKE}}::greet world
} -result {Hello, world!}

cleanupTests
```

The first argument is a name tcltest matches `-match` and `-skip` patterns
against; the second is the sentence a reader needs. Both are printed when a
test fails.

`cleanupTests` is not optional. Each file runs in its own interpreter and
reports its totals on one line, which is what the parent reads to decide
whether the run failed — a file that never calls it looks like a file that ran
no tests.

`[info script]` is the path of the file being sourced, so the `source` line
above resolves against `tests/` rather than the working directory. That is what
lets a single test file be run on its own:

```console
$ make shell
$ tclsh tests/greet.test
```

## Lint

`make lint` byte-compiles every `.tcl` and `.test` file and fails on a parse
error, which is the only thing Tcl can know about code it has not run.

It is worth knowing exactly how narrow that is. Tcl has no static types and no
compile-time name resolution: a misspelled command is an ordinary runtime
error, and a `proc` body is not compiled until the proc is first called — so a
parse error inside one surfaces under `make test`, not here. What lint catches
is the file-level damage: an unbalanced brace, bracket or quote, a stray
character after a closing one, and a malformed `expr`.

The check reads the `syntax` instruction out of the bytecode, because nothing
in Tcl raises on a parse error you have not executed. `tclsh` itself only
reports one when it reaches the broken command.

## There is no formatter

No Tcl formatter exists — none in Debian, and no third-party one stable enough
to pin. `make fmt` says so and does nothing, and `.editorconfig` is what keeps
the layout consistent.

## Adding a dependency

Tcl's answer is `package require`, backed by a `pkgIndex.tcl` that
`package ifneeded` lines point at. There is nothing in this project yet,
because a single-directory project does not need one: `source` with a path
relative to `[info script]` reaches a file in `src/` and costs nothing to read.

Reach for a real package once two directories need the same code, and install
it in the `Dockerfile` so the container stays the pin.

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
3. [Repeat until](https://github.com/acodeninja/bootstrap/blob/main/docs/katas/everything-is-a-string.md) — a control structure of your own, in the caller's frame

Then, when the group wants more: [Word wrap](https://github.com/acodeninja/bootstrap/blob/main/docs/katas/word-wrap.md) → [String calculator](https://github.com/acodeninja/bootstrap/blob/main/docs/katas/string-calculator.md).

The rest of the catalogue, and why this language gets these, is in
[docs/katas](https://github.com/acodeninja/bootstrap/tree/main/docs/katas).

Delete this section when the project becomes real work.

## Licence

MIT — see [LICENSE](LICENSE).
