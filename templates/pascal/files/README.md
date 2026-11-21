# {{PROJECT_NAME}}

## Prerequisites

- **Docker**, with the daemon running
- **make** — on Windows, `winget install ezwinports.make`

You do not need Free Pascal. The toolchain lives in the container, pinned by the
`Dockerfile`, so a green suite here is a green suite anywhere.

## Commands

```console
$ make test    # run the test suite
$ make lint    # compile every unit, warnings included
$ make fmt     # a no-op: Free Pascal ships no usable formatter
$ make build   # compile the project into /cache
$ make shell   # open a shell in the container
```

## Tests

Tests are fpcunit `TTestCase` classes. Every `published` method is a test, found
through RTTI rather than named anywhere, and `RegisterTest` at the foot of the
unit adds the class to the suite.

The program that runs them is generated: it needs a `uses` clause naming each
test unit, so the image writes one from whatever is in `tests/`. Add a unit
there and `make test` picks it up; delete one and it stops looking for it.

A unit name is an identifier like any other, which is why these are
`*_test.pas`: a unit called `greet` would hide a function called `Greet`.

## There is no formatter

`ptop` ships with Free Pascal and was tried. It capitalises every keyword, moves
`end;` to column zero inside a procedure, and leaves trailing whitespace after
`var` — so running it would make the source worse and fight `.editorconfig`.
Nothing else is packaged.

`make lint` therefore checks compilation rather than layout, with `-Sew` so that
warnings fail: an unused variable, an uninitialised managed result, an
unreachable branch. `.editorconfig` is what keeps the layout honest.

## Adding a dependency

Free Pascal has no package manager in this image. The FCL is already installed,
which covers containers, strings, streams and JSON — `uses Classes, SysUtils,
fpjson` needs nothing added.

For anything else, install the Debian package in the `Dockerfile` and run
`docker compose build`. `apt-cache search fp-units` lists what is available.

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

## Licence

MIT — see [LICENSE](LICENSE).
