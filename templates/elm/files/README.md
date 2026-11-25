# {{PROJECT_NAME}}

## Prerequisites

- **Docker**, with the daemon running
- **make** — on Windows, `winget install ezwinports.make`

You do not need Elm or Node. The toolchain lives in the container, pinned by the
`Dockerfile`, so a green suite here is a green suite anywhere.

## Commands

```console
$ make test    # run the test suite
$ make lint    # check formatting
$ make fmt     # reformat in place
$ make build   # compile the module and its dependencies
$ make shell   # open a shell in the container
```

## Layout

`elm.json` lists `src/{{PROJECT_SNAKE}}` as its only source directory, so the module
inside it is plain `Greeter`. An Elm module name has to match its path below a
source directory and start with a capital letter, and a lowercased project name
cannot, so the project name is the directory rather than a module prefix.

Tests live in `tests/`, where `elm-test` finds them with nothing declaring them.

## Adding a dependency

```console
$ make shell
$ elm install elm/regex
```

That rewrites `elm.json` in your project and caches the package in the
container's `/cache` volume. The compiler and the test runner live outside your
project, in the image — to change those, edit `package.json` and run
`docker compose build`.

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
3. [Form state](https://github.com/acodeninja/bootstrap/blob/main/docs/katas/illegal-states-unrepresentable.md) — a type in which the wrong state cannot be written

Then, when the group wants more: [Word wrap](https://github.com/acodeninja/bootstrap/blob/main/docs/katas/word-wrap.md) → [Tennis](https://github.com/acodeninja/bootstrap/blob/main/docs/katas/tennis.md) → [Turnstile](https://github.com/acodeninja/bootstrap/blob/main/docs/katas/turnstile.md).

The rest of the catalogue, and why this language gets these, is in
[docs/katas](https://github.com/acodeninja/bootstrap/tree/main/docs/katas).

Delete this section when the project becomes real work.

## Licence

MIT — see [LICENSE](LICENSE).
