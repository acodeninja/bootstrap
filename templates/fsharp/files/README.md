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

`.github/workflows/ci.yml` needs two repository secrets, `DOCKERHUB_USERNAME`
and `DOCKERHUB_TOKEN`. Docker Hub rate-limits anonymous pulls and GitHub's
runners share IP addresses, so without them CI fails with a registry error that
looks nothing like the real cause.

## Licence

MIT — see [LICENSE](LICENSE).
