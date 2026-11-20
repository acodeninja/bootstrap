# {{PROJECT_NAME}}

## Prerequisites

- **Docker**, with the daemon running
- **make** — on Windows, `winget install ezwinports.make`

You do not need Clojure or a JDK. The toolchain lives in the container, pinned
by the `Dockerfile`, so a green suite here is a green suite anywhere.

## Commands

```console
$ make test    # run the test suite
$ make lint    # check lint rules and formatting
$ make fmt     # reformat in place
$ make build   # resolve dependencies and cache the classpath
$ make shell   # open a shell in the container
```

Every run starts a JVM, so expect a few seconds even when nothing has changed.
Caching removes the dependency resolution, not the startup.

## Tests

Tests live under `test/`, one namespace per file, named `*-test` by convention
rather than by requirement. `make test` runs the `:test` alias, which hands
`test/` to a `clojure.test` runner baked into the image: it reads each file's
own `(ns ...)` form and runs every namespace it finds. Adding a test file needs
no registration anywhere.

Namespaces use hyphens and filenames use underscores — the namespace
`{{PROJECT_SLUG}}.greeter` lives at `src/{{PROJECT_SNAKE}}/greeter.clj`.

## Adding a dependency

Add the coordinate to `deps.edn`, then:

```console
$ make build
```

Dependencies download into `/cache` inside the container, so they survive
between runs and never land in your project. `clj-kondo` and `cljfmt` are not
dependencies at all: they are native binaries in the image, so `deps.edn` stays
yours.

## CI

`.github/workflows/ci.yml` needs two repository secrets, `DOCKERHUB_USERNAME`
and `DOCKERHUB_TOKEN`. Docker Hub rate-limits anonymous pulls and GitHub's
runners share IP addresses, so without them CI fails with a registry error that
looks nothing like the real cause.

## Licence

MIT — see [LICENSE](LICENSE).
