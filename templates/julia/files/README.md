# {{PROJECT_NAME}}

## Prerequisites

- **Docker**, with the daemon running
- **make** — on Windows, `winget install ezwinports.make`

You do not need Julia. The toolchain lives in the container, pinned by the
`Dockerfile`, so a green suite here is a green suite anywhere.

## Commands

```console
$ make test    # run the test suite
$ make lint    # check formatting
$ make fmt     # reformat in place
$ make build   # precompile the project into the cache
$ make shell   # open a shell in the container
```

`make build` is a real step rather than the no-op an interpreted language
usually gets: Julia compiles a package the first time it is loaded and keeps
the result, so `make build` pays that cost once and `make test` then starts
warm. Nothing is produced in your working tree.

## Tests

`Pkg.test()` runs `test/runtests.jl` and nothing else, so that file globs the
directory beside it and includes what it finds. Add a `.jl` file under `test/`
and `make test` picks it up; delete one and it stops looking for it.

Tests are stdlib `Test`: a `@testset` names the behaviour and `@test` asserts
it. `@test_throws` is how a refusal is asserted.

## Lint is the formatter

Julia has no separate linter worth pinning, so `make lint` is JuliaFormatter in
check mode — it reports the files it would rewrite and exits non-zero without
touching them. `make fmt` is the same tool writing in place. Both reach it
through `julia -m JuliaFormatter`, which is the `jlfmt` command line under
another name.

## The package name and its UUID

`Project.toml` carries the two things Julia identifies a package by, and both
came from the template:

- **The name** is your project name lowercased with underscores, because that
  is what a Julia identifier allows and the module in `src/` has to match it.
  Julia itself would spell it `UpperCamelCase`; rename all three — the `name`,
  the file and the `module` line — if that matters to you.
- **The UUID** is fixed, so every project scaffolded from this template shares
  it. That is harmless while the package lives only on your own machine, and
  wrong the moment you publish it to a registry, where the UUID is the identity
  two packages must not share. Generate your own then — `make shell`, then
  `julia -e 'using UUIDs; println(uuid4())'` — and paste it in.

`Manifest.toml` is gitignored, which is the convention for a package rather
than an application: it records the exact versions resolved for one machine,
and `Pkg` rewrites it on every `make test`.

## Adding a dependency

```console
$ make shell
# julia --project=. -e 'using Pkg; Pkg.add("JSON")'
```

That writes the dependency into `Project.toml`, which is the file to commit.
The download and the precompiled copy land in the cache volume, so the next
`make test` finds them already there.

Development tools are different: they belong in the `Dockerfile`, installed
into the image's own shared environment the way JuliaFormatter is, so they stay
out of the dependency list of the thing you are building.

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
