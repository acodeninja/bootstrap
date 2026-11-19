# {{PROJECT_NAME}}

## Prerequisites

- **Docker**, with the daemon running
- **make** — on Windows, `winget install ezwinports.make`

You do not need Node. The toolchain lives in the container, pinned by the
`Dockerfile`, so a green suite here is a green suite anywhere.

## Commands

```console
$ make test    # run the test suite
$ make lint    # check lint rules and formatting
$ make fmt     # reformat in place
$ make build   # a no-op: JavaScript runs from source
$ make shell   # open a shell in the container
```

## Adding a dependency

```console
$ make shell
$ npm install some-package
```

That writes to `node_modules/` in your project, which the container picks up on
the next run. The linter and formatter live outside your project at
`/node_modules` in the image — to change those, edit `package.json` and run
`docker compose build`.

## CI

`.github/workflows/ci.yml` needs two repository secrets, `DOCKERHUB_USERNAME`
and `DOCKERHUB_TOKEN`. Docker Hub rate-limits anonymous pulls and GitHub's
runners share IP addresses, so without them CI fails with a registry error that
looks nothing like the real cause.

## Licence

MIT — see [LICENSE](LICENSE).
