# {{PROJECT_NAME}}

## Prerequisites

- **Docker**, with the daemon running
- **make** — on Windows, `winget install ezwinports.make`

You do not need D. The toolchain lives in the container, pinned by the
`Dockerfile`, so a green suite here is a green suite anywhere.

## Commands

```console
$ make test    # run the test suite
$ make lint    # check style rules
$ make fmt     # reformat in place
$ make build   # compile the library
$ make shell   # open a shell in the container
```

## Tests

Tests are `unittest` blocks, and they live in the module they test rather than
in a tree of their own. `dub test` compiles everything under `src/` with
`-unittest` and runs every block it finds, so a new file is picked up by
existing — nothing lists it anywhere.

The string attribute above a block, `@("a greeting addresses the name it is
given")`, names it. druntime's runner reports a module at a time rather than a
name, so a failure points at a file and a line; the name is there for whoever
reads the file next.

## The garbage collector

D is a systems language with a tracing collector, which is unusual enough to be
worth saying out loud: `~=` on an array, `format`, and an associative array
literal all allocate, and nothing in this project frees anything.

Where that is the wrong trade, you opt out per function rather than per project.
`@nogc` makes an allocation in that function a compile error, `@safe` rules out
pointer arithmetic and casts that could break memory safety, and both are
checked rather than advisory. `make build` is where you find out.

## Lint and formatting are separate tools

`make lint` is [D-Scanner](https://github.com/dlang-community/D-Scanner) in
`--styleCheck` mode, which reads the code without touching it and exits non-zero
on a finding — an unmodified variable that could be `const`, an undocumented
public declaration, a condition that cannot be false. `make fmt` is
[dfmt](https://github.com/dlang-community/dfmt), which rewrites in place.

Neither is packaged for Debian and neither publishes a release binary, so the
`Dockerfile` builds both from pinned source tarballs with the compiler it
already needs. They are the dlang-community tools, not third-party ones.

dfmt reads `.editorconfig`, so the indentation your editor uses and the
indentation the formatter imposes are the same setting.

## Adding a dependency

```console
$ make shell
$ dub add some-package
```

That writes to `dub.json` and creates `dub.selections.json`, which pins the
resolved versions and belongs in git. The package cache lives at `/cache/dub` in
the named volume rather than in your project, so adding a dependency needs no
rebuild of the image.

Build output goes to `bin/`, which is also a named volume — the directory is
there so dub has somewhere to write, and it stays empty on the host.

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
