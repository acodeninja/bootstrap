# {{PROJECT_NAME}}

## Prerequisites

- **Docker**, with the daemon running
- **make** — on Windows, `winget install ezwinports.make`

You do not need Gleam or Erlang. The toolchain lives in the container, pinned
by the `Dockerfile`, so a green suite here is a green suite anywhere.

## Commands

```console
$ make test    # run the test suite
$ make lint    # check formatting and types
$ make fmt     # reformat in place
$ make build   # compile to BEAM bytecode
$ make shell   # open a shell in the container
```

## Tests

`gleam test` runs `main` in `test/{{PROJECT_SNAKE}}_test.gleam`, and
`gleeunit.main()` there globs `test/` at run time for every function whose name
ends in `_test`. A new test file needs no declaration anywhere — add it and run
`make test`.

## Adding a dependency

```console
$ make shell
$ gleam add some_package
```

That updates `gleam.toml` and `manifest.toml`, which pins the exact version and
checksum of every package. The compiled result lives in the `build` named
volume rather than in your project, so `build/` on the host stays empty.

## CI

`.github/workflows/ci.yml` builds the image and runs lint and tests on every
push, and needs no secrets to do it.

`DOCKERHUB_USERNAME` and `DOCKERHUB_TOKEN` are optional, and worth setting only
if the build starts failing to pull its base image: Docker Hub rate-limits
anonymous pulls and GitHub's runners share IP addresses, so the error looks
nothing like the real cause.

## Licence

MIT — see [LICENSE](LICENSE).
