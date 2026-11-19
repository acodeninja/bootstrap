# {{PROJECT_NAME}}

## Prerequisites

- **Docker**, with the daemon running
- **make** — on Windows, `winget install ezwinports.make`

You do not need Dart. The toolchain lives in the container, pinned by the
`Dockerfile`, so a green suite here is a green suite anywhere.

## Commands

```console
$ make test    # run the test suite
$ make lint    # check lint rules and formatting
$ make fmt     # reformat in place
$ make build   # a no-op: Dart runs from source
$ make shell   # open a shell in the container
```

## Adding a dependency

```console
$ make shell
$ dart pub add some_package
```

That writes to `pubspec.yaml` and `pubspec.lock` in your project. Packages are
downloaded into a cache volume, so the next run picks them up without
touching the network again.

## CI

`.github/workflows/ci.yml` needs two repository secrets, `DOCKERHUB_USERNAME`
and `DOCKERHUB_TOKEN`. Docker Hub rate-limits anonymous pulls and GitHub's
runners share IP addresses, so without them CI fails with a registry error that
looks nothing like the real cause.

## Licence

MIT — see [LICENSE](LICENSE).
