# {{PROJECT_NAME}}

## Prerequisites

- **Docker**, with the daemon running
- **make** — on Windows, `winget install ezwinports.make`

You do not need Elixir. The toolchain lives in the container, pinned by the
`Dockerfile`, so a green suite here is a green suite anywhere.

## Commands

```console
$ make test    # run the test suite
$ make lint    # check lint rules and formatting
$ make fmt     # reformat in place
$ make build   # compile the project
$ make shell   # open a shell in the container
```

## Tests

`mix test` discovers every `test/**/*_test.exs` itself, so a new test file
needs no declaration anywhere — add it and run `make test`.

## Adding a dependency

Add the package to `deps()` in `mix.exs`, then:

```console
$ make shell
$ mix deps.get
```

Dependencies, their compiled build, and the lock file all live outside your
project, in the named cache volume — `mix.exs` points `:lockfile` at
`/cache/mix.lock`, so nothing is written into the project root.

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
3. [Word wrap](https://github.com/acodeninja/bootstrap/blob/main/docs/katas/word-wrap.md) — splitting a string, and recursion
4. [Tennis](https://github.com/acodeninja/bootstrap/blob/main/docs/katas/tennis.md) — a closed set of states, and a branch that yields a value
5. [Turnstile](https://github.com/acodeninja/bootstrap/blob/main/docs/katas/turnstile.md) — a state machine, and a transition that carries an action

The rest of the catalogue, and why this language gets these, is in
[docs/katas](https://github.com/acodeninja/bootstrap/tree/main/docs/katas).

Delete this section when the project becomes real work.

## Licence

MIT — see [LICENSE](LICENSE).
