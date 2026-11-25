# {{PROJECT_NAME}}

## Prerequisites

- **Docker**, with the daemon running
- **make** — on Windows, `winget install ezwinports.make`

You do not need Ruby. The toolchain lives in the container, pinned by the
`Dockerfile`, so a green suite here is a green suite anywhere.

## Commands

```console
$ make test    # run the test suite
$ make lint    # check lint rules and formatting
$ make fmt     # reformat in place
$ make build   # a no-op: Ruby runs from source
$ make shell   # open a shell in the container
```

## Tests

`rake test` runs every `test/**/*_test.rb`, so a new test file needs no
declaration anywhere — add it and run `make test`.

## Adding a dependency

This project ships no `Gemfile`, because it has no dependencies. RuboCop lives
outside your project, in the image at `/usr/local/bundle`. Adding your first
dependency writes the `Gemfile` for you:

```console
$ make shell
$ bundle init
$ bundle add some-gem
```

A gem with a native extension needs a compiler, which this image does not
carry — add `build-essential` to the `Dockerfile` and run
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
3. [Each slice, by hand](https://github.com/acodeninja/bootstrap/blob/main/docs/katas/blocks-and-enumerable.md) — the block every method already takes

Then, when the group wants more: [Roman numerals](https://github.com/acodeninja/bootstrap/blob/main/docs/katas/roman-numerals.md) → [Bowling](https://github.com/acodeninja/bootstrap/blob/main/docs/katas/bowling.md) → [Mars Rover](https://github.com/acodeninja/bootstrap/blob/main/docs/katas/mars-rover.md).

The rest of the catalogue, and why this language gets these, is in
[docs/katas](https://github.com/acodeninja/bootstrap/tree/main/docs/katas).

Delete this section when the project becomes real work.

## Licence

MIT — see [LICENSE](LICENSE).
