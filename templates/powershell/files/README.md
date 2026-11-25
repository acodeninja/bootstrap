# {{PROJECT_NAME}}

## Prerequisites

- **Docker**, with the daemon running
- **make** — on Windows, `winget install ezwinports.make`

You do not need PowerShell, even on Windows. The toolchain lives in the
container, pinned by the `Dockerfile`, so a green suite here is a green suite
anywhere — and the PowerShell inside it is the cross-platform 7.x, not the
Windows PowerShell 5.1 that ships with the operating system.

## Commands

```console
$ make test    # run the test suite
$ make lint    # check lint rules and formatting
$ make fmt     # reformat in place
$ make build   # a no-op: PowerShell runs from source
$ make shell   # open a shell in the container
```

## Tests

[Pester](https://pester.dev/) is the test framework, installed into the image
from the PowerShell Gallery. Every `*.Tests.ps1` file under `src/` and `tests/`
is found and run; add one and it runs, delete one and nothing refers to it.

```powershell
BeforeAll {
    . "$PSScriptRoot/../src/{{PROJECT_SNAKE}}.ps1"
}

Describe 'Get-Greeting' {
    It 'addresses the name it is given' {
        Get-Greeting -Name 'world' | Should -Be 'Hello, world!'
    }
}
```

`Describe` is not decoration. Pester discovers tests by running the file and
collecting what it finds, and an `It` outside a `Describe` or a `Context` is a
discovery error — so every test lives inside one.

`BeforeAll` runs once per file, before discovery completes, which is why the
dot-source belongs there rather than at the top of the file. `$PSScriptRoot` is
the directory of the file being run, so the path resolves against `tests/`
rather than the working directory.

`Should` is the assertion, and it is a long way from a single `assert`:
`-Be`, `-BeExactly`, `-Match`, `-Throw`, `-BeNullOrEmpty`, `-Contain`. Run
`Get-Help about_Should` in `make shell` for the full set.

### Why `make test` is not `Invoke-Pester -CI`

`-CI` looks like the obvious spelling and this project does not use it, for two
reasons worth knowing before you add it back. It writes `testResults.xml` into
the project directory, which is a bind mount that is supposed to stay clean.
And generating that report asks the operating system for the current user's
name, which at a container uid with no passwd entry prints an error from `id`
on stderr after every otherwise green run.

What `-CI` was wanted for is the non-zero exit code, and that is `Run.Exit` on
its own. `pwsh-test` in the image sets exactly that.

It also guards the empty case: Pester raises "No test files were found" rather
than reporting a run of nothing, so deleting the last test file would fail the
build if the driver did not check first.

## Lint

`make lint` is `Invoke-ScriptAnalyzer` with `-EnableExit`, which exits with the
number of findings. The rules live in `PSScriptAnalyzerSettings.psd1`, and
`make fmt` is `Invoke-Formatter` reading the same file — one set of rules, so
the formatter cannot produce a file the linter rejects.

`IncludeDefaultRules` is on, so a rule added upstream arrives enabled rather
than quietly missing. Two deliberate choices sit beside it:

`PSUseDeclaredVarsMoreThanAssignments` is excluded. A Pester file is a script
of bare `Describe` and `It` calls, and the rule reads every assignment inside
one as a variable nobody went on to use.

`PSAlignAssignmentStatement` is absent rather than disabled, and the comment in
the settings file says why: it pads the left of an `=` so a block of
assignments lines up, and `PSUseConsistentWhitespace`'s `CheckOperator` then
rejects that padding as more than one space around an operator. `Invoke-Formatter`
applies the alignment, so turning both on makes `make fmt` produce a file
`make lint` refuses.

Indentation is set in `PSScriptAnalyzerSettings.psd1` rather than in
`.editorconfig`, because the analyzer is what enforces it. `.editorconfig` is
still there and agrees with it, for the benefit of your editor.

## Adding a dependency

A dependency is a module. Install it in the `Dockerfile` so the container stays
the pin:

```dockerfile
RUN pwsh -NoLogo -NoProfile -Command " \
      Install-Module -Name SomeModule -RequiredVersion '1.2.3' -Scope AllUsers -Force"
```

`-RequiredVersion` is the part that matters; without it the build installs
whatever the Gallery published most recently, and two builds a week apart are
two different projects. `-Scope AllUsers` puts the module under
`/usr/local/share/powershell`, in the image, rather than in the `/cache`
volume where a later run could change it.

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
3. [Largest files](https://github.com/acodeninja/bootstrap/blob/main/docs/katas/the-object-pipeline.md) — a pipeline that carries objects rather than text

Then, when the group wants more: [Word wrap](https://github.com/acodeninja/bootstrap/blob/main/docs/katas/word-wrap.md) → [String calculator](https://github.com/acodeninja/bootstrap/blob/main/docs/katas/string-calculator.md) → [Diamond](https://github.com/acodeninja/bootstrap/blob/main/docs/katas/diamond.md).

The rest of the catalogue, and why this language gets these, is in
[docs/katas](https://github.com/acodeninja/bootstrap/tree/main/docs/katas).

Delete this section when the project becomes real work.

## Licence

MIT — see [LICENSE](LICENSE).
