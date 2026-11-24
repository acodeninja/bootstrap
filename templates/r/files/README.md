# {{PROJECT_NAME}}

## Prerequisites

- **Docker**, with the daemon running
- **make** — on Windows, `winget install ezwinports.make`

You do not need R. The toolchain lives in the container, pinned by the
`Dockerfile`, so a green suite here is a green suite anywhere.

## Commands

```console
$ make test    # run the test suite
$ make lint    # check lint rules and formatting
$ make fmt     # reformat in place
$ make build   # a no-op: R runs from source
$ make shell   # open a shell in the container
```

## Tests

`testthat` runs every `tests/test*.R`, so a new test file needs no declaration
anywhere — add it and run `make test`.

This project is not an R package, so nothing would otherwise load `src/` for
the tests. `make test` sources every `src/*.R` first, which is the job a
package's `NAMESPACE` would do.

## Lint and fmt disagree, and the code is written for both

`lintr` enforces the tidyverse's two-space indent and eighty-column lines.
`formatR` indents by four unless told otherwise and will happily join a
`switch` into an eighty-one column line — which `make lint` then rejects.

So `make fmt` passes `indent = 2`, and the shipped code is written so that
`fmt` changes nothing and `lint` finds nothing. If you add a long `switch` or
an inline `if`/`else`, expect to meet this: run `make fmt` then `make lint`,
and shape the code until both are quiet.

## Adding a dependency

R packages come from the image rather than from your project. `testthat`,
`lintr` and `formatR` are installed as Debian packages, which is also how to
add one:

```dockerfile
RUN apt-get update \
    && apt-get install -y --no-install-recommends r-cran-jsonlite \
    && rm -rf /var/lib/apt/lists/*
```

`apt-cache search '^r-cran-'` lists what is available — several hundred
packages, including most of the tidyverse. For anything not packaged,
`install.packages()` in the `Dockerfile` works, but it compiles from source and
pins nothing, so prefer the Debian package where one exists.

## Why not the official R image

`r-base` is built on Debian testing, so its package set moves under a fixed
tag: pinning the R libraries there rots as testing rotates them out, and not
pinning them means this project scaffolds differently next month. A datestamped
stable base fixes every version at once. The cost is R 4.5.0 rather than the
newest release.

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
3. [Bowling](https://github.com/acodeninja/bootstrap/blob/main/docs/katas/bowling.md) — index arithmetic, and reading ahead of yourself
4. [Game of Life](https://github.com/acodeninja/bootstrap/blob/main/docs/katas/game-of-life.md) — a grid, and a generation computed from the last one
5. [Diamond](https://github.com/acodeninja/bootstrap/blob/main/docs/katas/diamond.md) — symmetry, padding, and an output whose shape is the requirement

The rest of the catalogue, and why this language gets these, is in
[docs/katas](https://github.com/acodeninja/bootstrap/tree/main/docs/katas).

Delete this section when the project becomes real work.

## Licence

MIT — see [LICENSE](LICENSE).
