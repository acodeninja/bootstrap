# {{PROJECT_NAME}}

## Prerequisites

- **Docker**, with the daemon running
- **make** — on Windows, `winget install ezwinports.make`

You do not need the .NET SDK. The toolchain lives in the container, pinned by
the `Dockerfile`, so a green suite here is a green suite anywhere.

## Commands

```console
$ make test    # run the test suite
$ make lint    # check formatting
$ make fmt     # reformat in place
$ make build   # compile the project
$ make shell   # open a shell in the container
```

## Layout

One project, `{{PROJECT_SNAKE}}.fsproj`, holding both the module in `src/` and
the tests in `test/`. F# compiles files in the order the project lists them,
and the two wildcards expand alphabetically — a source file that another one
depends on needs its own `<Compile>` line above the `src/*.fs` glob.

`dotnet test` finds tests by reflection over the built assembly, so no file is
named anywhere and deleting a test file is all it takes to remove it.

`Directory.Build.props` sends `bin/` and `obj/` to `/cache`, which is a named
volume rather than your project. Removing it puts both back beside the source.

`global.json` opts `dotnet test` into Microsoft.Testing.Platform. xUnit v3 runs
there rather than on VSTest, and the .NET 10 SDK refuses the VSTest path for it,
so without that file `dotnet test` fails before running anything.

## Formatting

`dotnet format` handles C# and Visual Basic only; on an F# project it prints a
notice and exits 0. The formatter here is [Fantomas](https://fsprojects.github.io/fantomas/),
installed in the image, and it reads its settings from `.editorconfig`.

## Adding a dependency

```console
$ make shell
$ dotnet add package some-package
```

That writes the `PackageReference` into `{{PROJECT_SNAKE}}.fsproj`. The package
itself lands in the container's NuGet cache, so nothing new appears in your
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

## Course

Three katas, in this order, each introducing one thing the last one did not:

1. [Hello, World](https://github.com/acodeninja/bootstrap/blob/main/docs/katas/hello-world.md) — the toolchain, not you, and already solved beside this file
2. [FizzBuzz](https://github.com/acodeninja/bootstrap/blob/main/docs/katas/fizzbuzz.md) — a loop, a branch, and your first test
3. [Pace](https://github.com/acodeninja/bootstrap/blob/main/docs/katas/units-of-measure.md) — a number that knows what it measures

Then, when the group wants more: [Word wrap](https://github.com/acodeninja/bootstrap/blob/main/docs/katas/word-wrap.md) → [Tennis](https://github.com/acodeninja/bootstrap/blob/main/docs/katas/tennis.md) → [Turnstile](https://github.com/acodeninja/bootstrap/blob/main/docs/katas/turnstile.md).

The rest of the catalogue, and why this language gets these, is in
[docs/katas](https://github.com/acodeninja/bootstrap/tree/main/docs/katas).

Delete this section when the project becomes real work.

## Licence

MIT — see [LICENSE](LICENSE).
