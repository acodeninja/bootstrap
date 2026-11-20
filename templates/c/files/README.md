# {{PROJECT_NAME}}

## Prerequisites

- **Docker**, with the daemon running
- **make** — on Windows, `winget install ezwinports.make`

You do not need a compiler. The toolchain lives in the container, pinned by the
`Dockerfile`, so a green suite here is a green suite anywhere.

## Commands

```console
$ make test    # run the test suite
$ make lint    # check formatting
$ make fmt     # reformat in place
$ make build   # compile the library
$ make shell   # open a shell in the container
```

## Layout

`src/` holds the library, `test/` holds the tests, and `build.mk` holds the
compile rules. `make test` runs inside the container, where globbing works, so
every `test/*.c` file is found and compiled without being named anywhere —
including the one you add next.

Objects, the archive and the test binary are written to `/cache` inside the
container, not beside the source, so a second `make test` only recompiles what
you changed and your working tree stays clean.

## Vendored code

`vendor/unity/` is [Unity](https://github.com/ThrowTheSwitch/Unity) 2.7.0, the
test framework, copied in unmodified apart from a provenance header on each
file. C has no standard test framework and no package manager to fetch one
from, so it ships with the project.

Unity is **MIT licensed**, separately from this project's own
[LICENSE](LICENSE), and its copyright stays with its authors. `make lint` and
`make fmt` skip `vendor/` deliberately: reformatting someone else's code turns
the next upstream update into a merge conflict.

## CI

`.github/workflows/ci.yml` builds the image and runs lint and tests on every
push, and needs no secrets to do it.

`DOCKERHUB_USERNAME` and `DOCKERHUB_TOKEN` are optional, and worth setting only
if the build starts failing to pull its base image: Docker Hub rate-limits
anonymous pulls and GitHub's runners share IP addresses, so the error looks
nothing like the real cause.

## Licence

MIT — see [LICENSE](LICENSE).
