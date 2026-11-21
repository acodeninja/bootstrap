# {{PROJECT_NAME}}

## Prerequisites

- **Docker**, with the daemon running
- **make** — on Windows, `winget install ezwinports.make`

You do not need Swift. The toolchain lives in the container, pinned by the
`Dockerfile`, so a green suite here is a green suite anywhere.

## Commands

```console
$ make test    # run the test suite
$ make lint    # check formatting
$ make fmt     # reformat in place
$ make build   # compile the library
$ make shell   # open a shell in the container
```

Every `swift` invocation passes `--scratch-path /cache/build`, which keeps
`.build/` out of your project and inside the cache volume. Drop the flag and
the second run has nothing to reuse.

## Tests

`swift test` discovers both test libraries on its own, so a new test file needs
no registration anywhere. The kitchen sink is swift-testing — `@Test` on free
functions, asserted with `#expect` and `#require`. `tests/{{PROJECT_SNAKE}}_tests.swift`
stays on XCTest deliberately: `swift test` exits 2 on a test target with nothing
in it, so keeping one case there is what makes the kitchen sink safe to delete.

Formatting is checked by `swift format lint --strict`, over `src/`, `tests/` and
`Package.swift`; without `--strict` every finding is a warning and the command
exits 0 whatever it finds.

## Adding a dependency

```console
$ make shell
$ swift package --scratch-path /cache/build add-dependency https://github.com/apple/swift-algorithms --from 1.2.0
```

Then add it to the target's `dependencies` in `Package.swift`. SwiftPM writes a
`Package.resolved` next to the manifest the first time it resolves one, and
that file belongs in version control. Pass `--scratch-path` to anything you run
by hand in the shell too: without it SwiftPM puts `.build/` back in the
project.

## CI

`.github/workflows/ci.yml` builds the image and runs lint and tests on every
push, and needs no secrets to do it.

`.github/workflows/actions.lock` pins the actions that workflow uses to exact
commits, so a tag that moves upstream cannot change what runs. It is
machine-generated: after you add a workflow or edit a `uses:` line, install the
tool once with `gh extension install github/gh-actions-lock` and run
`gh actions-lock` to rebuild it. Turning on Dependabot for `github-actions`
keeps the workflow and the lockfile in step without that.

`DOCKERHUB_USERNAME` and `DOCKERHUB_TOKEN` are optional, and worth setting only
if the build starts failing to pull its base image: Docker Hub rate-limits
anonymous pulls and GitHub's runners share IP addresses, so the error looks
nothing like the real cause.

## Licence

MIT — see [LICENSE](LICENSE).
