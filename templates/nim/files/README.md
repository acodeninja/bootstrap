# {{PROJECT_NAME}}

## Prerequisites

- **Docker**, with the daemon running
- **make** — on Windows, `winget install ezwinports.make`

You do not need Nim. The toolchain lives in the container, pinned by the
`Dockerfile`, so a green suite here is a green suite anywhere.

## Commands

```console
$ make test    # run the test suite
$ make lint    # type-check the project
$ make fmt     # reformat in place
$ make build   # compile the project into /cache
$ make shell   # open a shell in the container
```

## Lint does not catch formatting

`nimpretty` has no check mode — it only rewrites a file, so it cannot stand in
for the non-mutating half of `lint`. `make lint` is `nim check`, a type check
that never looks at whitespace, so badly formatted but valid code passes it.
Run `make fmt` yourself before committing if you care about style.

## Adding a dependency

```console
$ make shell
$ nimble add some-package
```

## CI

`.github/workflows/ci.yml` builds the image and runs lint and tests on every
push, and needs no secrets to do it.

`DOCKERHUB_USERNAME` and `DOCKERHUB_TOKEN` are optional, and worth setting only
if the build starts failing to pull its base image: Docker Hub rate-limits
anonymous pulls and GitHub's runners share IP addresses, so the error looks
nothing like the real cause.

## Licence

MIT — see [LICENSE](LICENSE).
