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

One project, `{{PROJECT_SNAKE}}.vbproj`, holding both the module in `src/` and the
tests in `test/`. The SDK globs `**/*.vb` by default, so no file list names the
test suite anywhere — deleting a test file is all it takes to remove it.

`dotnet test` finds tests by reflection over the built assembly, so `make
test` doesn't name one either.

`Directory.Build.props` sends `bin/` and `obj/` to `/cache`, which is a named
volume rather than your project. Removing it puts both back beside the source.

`global.json` opts `dotnet test` into Microsoft.Testing.Platform. xUnit v3 runs
there rather than on VSTest, and the .NET 10 SDK refuses the VSTest path for
it, so without that file `dotnet test` fails before running anything.

## The four options in the project file

`{{PROJECT_SNAKE}}.vbproj` turns on three compiler options VB leaves off by default, and
empties a fourth. They are the difference between VB as a typed language and VB
as a late-bound one, so they are worth knowing before you turn any of them off.

`OptionStrict` rejects narrowing conversions and late binding. With it off, a
`String` flows into an `Integer` with no cast and the failure waits until
runtime. `OptionInfer` lets `Dim x = expr` take its type from the expression;
with it off and `OptionStrict` on, the same line is an error, and with both off
it silently yields `Object`. `OptionExplicit` requires a variable to be
declared before use.

`RootNamespace` is empty, which is not the SDK's default. VB prefixes every
`Namespace` you declare with the root one, and the root defaults to the
assembly name — so `Namespace Greeting` would really be `{{PROJECT_SNAKE}}.Greeting`,
and renaming the project would rename your namespaces with it.

## Tests

xUnit v3, with `<Fact>` on a `Public Sub`:

```vb
Imports Xunit

Namespace GreeterTests

    Public Class GreeterTests

        <Fact>
        Public Sub AGreetingAddressesTheNameItIsGiven()
            Dim name = "world"

            Dim result = Greeting.Greeter.Greet(name)

            Assert.Equal("Hello, world!", result)
        End Sub

    End Class

End Namespace
```

The local is `result` rather than `greeting` on purpose. VB identifiers are
case-insensitive, so a local named `greeting` is the same name as the namespace
`Greeting` — and the compiler reports it as a type it cannot infer, several
lines from the line you would suspect.

`Assert.Throws(Of T)` returns the exception, so a test can assert on the
message or the parameter name rather than only on the type.

## Lint

`make lint` is `dotnet format --verify-no-changes`, and it is a real check:
verified red, exit 2, on a deliberately mangled indent.

That is worth saying because the same tool is not a real check everywhere.
`dotnet format` supports C# and Visual Basic and nothing else; handed an F#
project it prints a notice and exits 0. Here it reads `.editorconfig` and
fails on a diff.

## Adding a dependency

```console
$ make shell
$ dotnet add package some-package
```

That writes the `PackageReference` into `{{PROJECT_SNAKE}}.vbproj`. The package itself
lands in the container's NuGet cache, so nothing new appears in your project.

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

Five katas, in this order, each introducing one thing the last one did not:

1. [Hello, World](https://github.com/acodeninja/bootstrap/blob/main/docs/katas/hello-world.md) — the toolchain, not you
2. [FizzBuzz](https://github.com/acodeninja/bootstrap/blob/main/docs/katas/fizzbuzz.md) — a loop, a branch, and your first test
3. [Roman numerals](https://github.com/acodeninja/bootstrap/blob/main/docs/katas/roman-numerals.md) — an ordered table, and a string you built
4. [Bowling](https://github.com/acodeninja/bootstrap/blob/main/docs/katas/bowling.md) — index arithmetic, and reading ahead of yourself
5. [Mars Rover](https://github.com/acodeninja/bootstrap/blob/main/docs/katas/mars-rover.md) — records, enums, parsing, and a failure worth reporting

The rest of the catalogue, and why this language gets these, is in
[docs/katas](https://github.com/acodeninja/bootstrap/tree/main/docs/katas).

Delete this section when the project becomes real work.

## Licence

MIT — see [LICENSE](LICENSE).
