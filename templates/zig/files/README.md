# {{PROJECT_NAME}}

## Prerequisites

- **Docker**, with the daemon running
- **make** — on Windows, `winget install ezwinports.make`

You do not need Zig. The toolchain lives in the container, pinned by the
`Dockerfile`, so a green suite here is a green suite anywhere.

## Commands

```console
$ make test    # run the test suite
$ make lint    # check formatting
$ make fmt     # reformat in place
$ make build   # compile the library into zig-out
$ make shell   # open a shell in the container
```

## Tests

Zig puts tests beside the code they cover, in the same file, and `build.zig`
names the files that hold them — there is no discovery. A new test file needs a
line in `build.zig` before `make test` will run it.

## Adding a dependency

This project ships no `build.zig.zon`, because it has no dependencies. Adding
the first one writes the file for you:

```console
$ make shell
$ zig fetch --save <url>
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
