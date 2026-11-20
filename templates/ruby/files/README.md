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

`DOCKERHUB_USERNAME` and `DOCKERHUB_TOKEN` are optional, and worth setting only
if the build starts failing to pull its base image: Docker Hub rate-limits
anonymous pulls and GitHub's runners share IP addresses, so the error looks
nothing like the real cause.

## Licence

MIT — see [LICENSE](LICENSE).
