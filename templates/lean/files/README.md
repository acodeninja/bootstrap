# {{PROJECT_NAME}}

## Prerequisites

- **Docker**, with the daemon running
- **make** — on Windows, `winget install ezwinports.make`

You do not need Lean or elan. The toolchain lives in the container, pinned by
the `Dockerfile`, so a green suite here is a green suite anywhere.

## Commands

```console
$ make test    # run the test suite
$ make lint    # typecheck every module, warnings included
$ make fmt     # a no-op: Lean ships no formatter
$ make build   # compile the library
$ make shell   # open a shell in the container
```

## Tests

`make test` is `lake test`, and the configured driver is the `test` library.
Lake builds a library driver rather than running it, so the assertions run as
the test files compile.

The library's files are found by a glob rather than named:

```toml
[[lean_lib]]
name = "test"
globs = ["test", "test.+"]
```

`test` is `test.lean`, the root module, and `test.+` is everything under
`test/`. Add a file there and `make test` picks it up; delete one and nothing
refers to it. Lake has no directory-wide discovery, so this glob is what makes
the suite deletable.

`test.lean` is the whole harness. There is no framework to install:

```lean
def check (name : String) (holds : Bool) : IO Unit :=
  unless holds do throw <| IO.userError name
```

An assertion is `#eval check "<a sentence>" <| <a Bool>`. `#guard` is the
shorter spelling and the suite does not use it, because it reports the
expression that failed rather than the claim you were making.

A second `make test` with nothing changed prints nothing and exits 0: Lake has
already built those modules, so the assertions do not run again.

## This is Lean the programming language

Lean 4 is a general-purpose functional language that happens to also be a proof
assistant. This template is the former: structures, inductive types, `match`,
`Option`, `Except`, `Std.HashMap`, mutable bindings inside `do`. Its memory is
reference counted rather than traced, so there is no garbage collector pause to
plan around, and an array held by one owner is updated in place.

Nothing here is a proof. If that is what you came for, start with
[Theorem Proving in Lean 4](https://lean-lang.org/theorem_proving_in_lean4/)
and [Mathlib](https://github.com/leanprover-community/mathlib4) instead — and
be ready for `make test` to take rather longer than it does now.

## There is no formatter

Lean publishes none. The release tarball carries `lean`, `lake`, `leanc` and a
bundled `clang`, and nothing that rewrites source — and a language whose macros
define their own notation is a hard target for an outside tool, which is why
there is no established third-party one either. `.editorconfig` is what keeps
the layout honest.

`make lint` therefore typechecks, which in Lean is most of a linter's job:

```toml
leanOptions = { warningAsError = true, autoImplicit = false, relaxedAutoImplicit = false }
```

`warningAsError` is what gives `lint` teeth — an unused binding is a warning,
and a warning is the kind of thing lint exists to refuse. `autoImplicit = false`
is the setting that turns a mistyped identifier into an error instead of a
silently invented implicit argument.

`lake lint --builtin-only --linters=linter.all` exists as well and is not used
here. It demands a doc string on every public declaration, and it only lints
the modules you name on the command line — which would mean naming the kitchen
sink.

## Where the build output goes

Lake writes everything to `.lake/` inside the project and has no flag or
environment variable to move it, so `compose.yaml` mounts a named volume there.
That keeps the build out of your checkout: `git status` after `make test` is
clean, and all that is left behind is an empty `.lake` directory.

The configuration is `lakefile.toml` rather than `lakefile.lean` for a related
reason. A Lean configuration file has to be elaborated and compiled before
anything else can build, and that compiled artefact is native code — so it
cannot be cached in the image for your machine to use. TOML needs none of it.

## Adding a dependency

Add a `[[require]]` to `lakefile.toml` and run `lake update` from
`make shell`:

```toml
[[require]]
name = "batteries"
scope = "leanprover-community"
```

`curl` and `git` are in the image for exactly this, and nothing else needs the
network.

Two things to know before you do it. `lake update` writes a `lean-toolchain`
file naming whatever toolchain the dependency was built against, which this
template deliberately does not ship: the `Dockerfile`'s `ARG LEAN_VERSION` is
the pin, and a second copy of a version number is a second thing to keep in
step. Pass `--keep-toolchain`, or bump the `ARG` and rebuild to match.

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
