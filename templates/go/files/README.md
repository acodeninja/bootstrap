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

`.github/workflows/ci.yml` needs two repository secrets, `DOCKERHUB_USERNAME`
and `DOCKERHUB_TOKEN`. Docker Hub rate-limits anonymous pulls and GitHub's
runners share IP addresses, so without them CI fails with a registry error that
looks nothing like the real cause.

## Licence

MIT — see [LICENSE](LICENSE).
