# {{PROJECT_NAME}}

## Prerequisites

- **Docker**, with the daemon running
- **make** — on Windows, `winget install ezwinports.make`

You do not need Rust. The toolchain lives in the container, pinned by the
`Dockerfile`, so a green suite here is a green suite anywhere.

## Commands

```console
$ make test    # run the test suite
$ make lint    # check lint rules and formatting
$ make fmt     # reformat in place
$ make build   # compile the crate
$ make shell   # open a shell in the container
```

## Adding a dependency

```console
$ make shell
$ cargo add some-crate
```

That writes to `Cargo.toml` and `Cargo.lock` in your project, which the
container picks up on the next run. The registry cache lives outside your
project at `/cache` in the named volume, so adding a dependency needs no
rebuild of the image itself.

## CI

`.github/workflows/ci.yml` needs two repository secrets, `DOCKERHUB_USERNAME`
and `DOCKERHUB_TOKEN`. Docker Hub rate-limits anonymous pulls and GitHub's
runners share IP addresses, so without them CI fails with a registry error that
looks nothing like the real cause.

## Licence

MIT — see [LICENSE](LICENSE).
