# {{PROJECT_NAME}}

## Prerequisites

- **Docker**, with the daemon running
- **make** — on Windows, `winget install ezwinports.make`

You do not need PHP. The toolchain lives in the container, pinned by the
`Dockerfile`, so a green suite here is a green suite anywhere.

## Commands

```console
$ make test    # run the test suite
$ make lint    # check lint rules and formatting
$ make fmt     # reformat in place
$ make build   # a no-op: PHP runs from source
$ make shell   # open a shell in the container
```

## Adding a dependency

```console
$ make shell
$ composer require some/package
```

That writes to `vendor/` and `composer.lock` in your project. PHPUnit,
PHPStan and php-cs-fixer are dev tools, not project dependencies — they live
outside your project at `/tools` in the image, so they never collide with a
`vendor/` you create yourself.

## CI

`.github/workflows/ci.yml` needs two repository secrets, `DOCKERHUB_USERNAME`
and `DOCKERHUB_TOKEN`. Docker Hub rate-limits anonymous pulls and GitHub's
runners share IP addresses, so without them CI fails with a registry error that
looks nothing like the real cause.

## Licence

MIT — see [LICENSE](LICENSE).
