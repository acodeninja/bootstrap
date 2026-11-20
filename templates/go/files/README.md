# {{PROJECT_NAME}}

## Prerequisites

- **Docker**, with the daemon running
- **make** — on Windows, `winget install ezwinports.make`

You do not need Go. The toolchain lives in the container, pinned by the
`Dockerfile`, so a green suite here is a green suite anywhere.

## Commands

```console
$ make test    # run the test suite
$ make lint    # check vet rules and formatting
$ make fmt     # reformat in place
$ make build   # compile every package
$ make shell   # open a shell in the container
```

## Adding a dependency

```console
$ make shell
$ go get some/module
$ go mod tidy
```

That writes to `go.mod` and `go.sum` in your project. The downloaded module
source lives outside your project, in the cache volume, so it survives
`docker compose down` and does not need re-fetching on the next run.

## CI

`.github/workflows/ci.yml` builds the image and runs lint and tests on every
push, and needs no secrets to do it.

`DOCKERHUB_USERNAME` and `DOCKERHUB_TOKEN` are optional, and worth setting only
if the build starts failing to pull its base image: Docker Hub rate-limits
anonymous pulls and GitHub's runners share IP addresses, so the error looks
nothing like the real cause.

## Licence

MIT — see [LICENSE](LICENSE).
