# {{PROJECT_NAME}}

## Prerequisites

- **Docker**, with the daemon running
- **make** — on Windows, `winget install ezwinports.make`

You do not need a JDK, Gradle or Kotlin. The toolchain lives in the container,
pinned by the `Dockerfile`, so a green suite here is a green suite anywhere.

## Commands

```console
$ make test    # run the test suite
$ make lint    # check formatting
$ make fmt     # reformat in place
$ make build   # compile and package into a jar
$ make shell   # open a shell in the container
```

## Layout

The module is `src/{{PROJECT_SNAKE}}.kt` and the tests are in `test/`, rather
than Gradle's `src/main/kotlin` and `src/test/kotlin`. `build.gradle.kts` sets
the two source roots; move them if you prefer the conventional layout.

Gradle's own output goes to `/cache` in the container rather than `build/` here,
so the project directory stays as you left it.

## Adding a dependency

```console
$ make shell
$ vi build.gradle.kts
```

Gradle resolves it on the next `make test`. Nothing is written to the project —
the download cache lives in the container's `/cache` volume.

## CI

`.github/workflows/ci.yml` needs two repository secrets, `DOCKERHUB_USERNAME`
and `DOCKERHUB_TOKEN`. Docker Hub rate-limits anonymous pulls and GitHub's
runners share IP addresses, so without them CI fails with a registry error that
looks nothing like the real cause.

## Licence

MIT — see [LICENSE](LICENSE).
