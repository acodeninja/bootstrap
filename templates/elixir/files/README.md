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

`DOCKERHUB_USERNAME` and `DOCKERHUB_TOKEN` are optional, and worth setting only
if the build starts failing to pull its base image: Docker Hub rate-limits
anonymous pulls and GitHub's runners share IP addresses, so the error looks
nothing like the real cause.

## Licence

MIT — see [LICENSE](LICENSE).
