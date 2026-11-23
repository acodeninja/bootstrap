# {{PROJECT_NAME}}

## Prerequisites

- **Docker**, with the daemon running
- **make** — on Windows, `winget install ezwinports.make`

You do not need SBCL. The toolchain lives in the container, pinned by the
`Dockerfile`, so a green suite here is a green suite anywhere.

## Commands

```console
$ make test    # run the test suite
$ make lint    # recompile every file, warnings included
$ make fmt     # a no-op: Common Lisp has no canonical formatter
$ make build   # compile the project into /cache
$ make shell   # open a shell in the container
```

## Tests

Tests are FiveAM `test` forms. Each one registers itself as it is compiled, and
`run-all-tests` runs every suite FiveAM has heard of — so nothing names a test
or a file.

ASDF does want a system's components listed, which the project's own
`{{PROJECT_SLUG}}.asd` does for `src/`. The test system is assembled in the
container instead, from whatever `test/*.lisp` holds at the moment you run it.
Add a file there and `make test` picks it up; delete one and it stops looking
for it.

## Compiled output goes to /cache

SBCL compiles every function it loads, and `compile-file` writes the `.fasl`
beside the source unless something says otherwise. That would leave a modified
file next to every one you edit, so the image sets
`ASDF_OUTPUT_TRANSLATIONS=/:/cache/fasl/` and the whole tree of compiled output
lands in a named volume. The first `make test` compiles; the second reuses.

Nothing writes into the project, which is why `git status` stays clean.

## There is no formatter

Common Lisp has no canonical formatter, and nothing packaged comes close:
indentation here is a function of what each macro means, which is why every
editor ships its own table of indent rules rather than a tool you can run.
`.editorconfig` is what keeps the layout honest.

`make lint` therefore checks compilation rather than layout. SBCL's compiler has
plenty to say — an undefined variable, a binding nothing reads, an argument of
the wrong type — and `lint` promotes all of it to a failure. It recompiles every
time, because a fasl that is already up to date is loaded in silence.

## Adding a dependency

Add the Debian Common Lisp package — they are the ones named `cl-*` — to the
`apt-get install` in the `Dockerfile`, run `docker compose build`, then name it
in `:depends-on` in `{{PROJECT_SLUG}}.asd`.

Quicklisp is deliberately absent. It resolves versions from a dist fetched at
load time, which would make a build depend on the network and on the day it ran
— the opposite of what the pinned image is for.

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
