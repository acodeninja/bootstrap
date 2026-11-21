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

One project, `{{PROJECT_SNAKE}}.csproj`, holding both the class in `src/` and
the tests in `test/`. The SDK globs `**/*.cs` by default, so no file list
names the test suite anywhere — deleting a test file is all it takes to
remove it.

`dotnet test` finds tests by reflection over the built assembly, so `make
test` doesn't name one either.

`Directory.Build.props` sends `bin/` and `obj/` to `/cache`, which is a named
volume rather than your project. Removing it puts both back beside the source.

`global.json` opts `dotnet test` into Microsoft.Testing.Platform. xUnit v3 runs
there rather than on VSTest, and the .NET 10 SDK refuses the VSTest path for
it, so without that file `dotnet test` fails before running anything.

## Adding a dependency

```console
$ make shell
$ dotnet add package some-package
```

That writes the `PackageReference` into `{{PROJECT_SNAKE}}.csproj`. The
package itself lands in the container's NuGet cache, so nothing new appears
in your project.

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
