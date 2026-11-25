# {{PROJECT_NAME}}

## Prerequisites

- **Docker**, with the daemon running
- **make** — on Windows, `winget install ezwinports.make`

You do not need Fortran. The toolchain lives in the container, pinned by the
`Dockerfile`, so a green suite here is a green suite anywhere.

## Commands

```console
$ make test    # run the test suite
$ make lint    # check formatting
$ make fmt     # reformat in place
$ make build   # compile the project
$ make shell   # open a shell in the container
```

## Tests

`fpm test` builds every file under `test/` that contains a `program` into its
own executable and runs all of them, so a new test file needs no declaration
anywhere — add it and run `make test`.

Assertions come from [test-drive](https://github.com/fortran-lang/test-drive),
pinned in `fpm.toml`. A test is a subroutine taking an `error` argument, and
`collect_*` is the one place a file lists its own tests.

## Lint is formatting

Fortran has no linter in wide use, so `make lint` is
[fprettify](https://github.com/fortran-lang/fprettify) in check mode and
`make fmt` is the same tool in place. Compilation errors come from
`make build`, not from `make lint`.

`.fprettify.rc` holds the formatter's settings and `.editorconfig` holds your
editor's. Both say four spaces; change them together.

## Adding a dependency

`fpm.toml` already has a `[dev-dependencies]` section. Dependencies are git
repositories pinned to a tag:

```toml
[dependencies]
stdlib.git = "https://github.com/fortran-lang/stdlib"
stdlib.tag = "v0.7.0"
```

fpm clones them into `build/`, which is a named volume rather than a directory
in your project. The image ships the dependencies this project starts with
already resolved, so a first run needs no network; adding one does.

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
3. [Smooth](https://github.com/acodeninja/bootstrap/blob/main/docs/katas/whole-array-operations.md) — the array as the unit of work

Then, when the group wants more: [Bowling](https://github.com/acodeninja/bootstrap/blob/main/docs/katas/bowling.md) → [Game of Life](https://github.com/acodeninja/bootstrap/blob/main/docs/katas/game-of-life.md) → [Diamond](https://github.com/acodeninja/bootstrap/blob/main/docs/katas/diamond.md).

The rest of the catalogue, and why this language gets these, is in
[docs/katas](https://github.com/acodeninja/bootstrap/tree/main/docs/katas).

Delete this section when the project becomes real work.

## Licence

MIT — see [LICENSE](LICENSE).
