# {{PROJECT_NAME}}

## Prerequisites

- **Docker**, with the daemon running
- **make** — on Windows, `winget install ezwinports.make`

You do not need Rakudo or zef. The toolchain lives in the container, pinned by
the `Dockerfile`, so a green suite here is a green suite anywhere.

## Commands

```console
$ make test    # run the test suite
$ make lint    # check every file compiles
$ make fmt     # a no-op: Raku has no working formatter
$ make build   # precompile every module in src/
$ make shell   # open a shell in the container
```

## Tests

`make test` is `prove6 -Isrc t`, so every `.rakutest` file under `t/` runs and
nothing names them. Add a file and it is picked up; delete one and nothing
refers to it.

`Test` is a core module, so the assertions need nothing installed. `prove6`
comes from Rakudo Star rather than from Rakudo itself, which is the reason this
image is the Star distribution.

```raku
use Test;
use lib 'src';
use {{PROJECT_SNAKE}};

is greet('world'), 'Hello, world!', 'a greeting addresses the name it is given';

done-testing;
```

`use lib 'src'` and `prove6`'s `-Isrc` do the same job twice on purpose: the
flag is what `make test` relies on, and the line is what lets you run a single
file by hand with `raku t/whatever.rakutest`.

`done-testing` rather than a `plan`, because a count at the top of the file is
one more thing to update every time you add a case.

## Types are checked where you ask for them

Raku's typing is gradual. `my $n = 1` is unchecked; `my Int $n = 1`,
`sub f(Str $s --> Int)` and `my Int @items` are checked at runtime, and a
`subset` with a `where` clause extends that from the type to the value:

```raku
subset Small of Int where * < 10;
```

A `subset` is a type like any other, so a `multi` can dispatch on one, and the
narrower candidate wins. `make lint` does not see any of this — `raku -c`
compiles without running, and a type check is a runtime check. The suite is
where constraints are proved.

## There is no formatter

The ecosystem has one candidate and it does not work. `Perl6::Tidy` 0.0.7 ships
a `perl6-tidy` binary, but it and `Perl6::Parser` 0.3.0 underneath it both died
in 2017 and reach into compiler internals that have since gone: on any input at
all they fail with `Cannot find method 'language_revision' on object of type
NQPMu`. It is also absent from the live `fez` ecosystem. Nothing else is
packaged.

`make lint` therefore checks compilation rather than layout. `raku -c` is a
real check mode — it compiles and does not run, so it is safe on any file —
and under Raku's default strictness an undeclared variable is a compile error
rather than a warning. `.editorconfig` is what keeps the layout honest.

## `make build` precompiles

Rakudo compiles a module to MoarVM bytecode the first time something `use`s it
and caches the result, so there is a real build step even though nothing is
linked. `make build` runs it for every module in `src/` without running the
tests.

The cache is the one thing Rakudo will not let you move: it goes in a
`.precomp` directory beside the source, with no flag or environment variable
to redirect it. `compose.yaml` mounts a named volume over `src/.precomp` so
the bytecode never lands in your checkout, which leaves an empty
`src/.precomp` directory behind and nothing else.

## Adding a dependency

There is no `META6.json`: the image is the dependency manifest. Add the module
to the `Dockerfile` with a version, then `docker compose build`.

```dockerfile
RUN zef --/test install 'JSON::Fast:ver<0.19>'
```

Quote the identity. `ver<...>` is shell metacharacters, and an unquoted pin is
silently a redirect rather than a version.

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
3. [Word wrap](https://github.com/acodeninja/bootstrap/blob/main/docs/katas/word-wrap.md) — splitting a string, and recursion
4. [String calculator](https://github.com/acodeninja/bootstrap/blob/main/docs/katas/string-calculator.md) — requirements that keep arriving, and errors reported together
5. [Diamond](https://github.com/acodeninja/bootstrap/blob/main/docs/katas/diamond.md) — symmetry, padding, and an output whose shape is the requirement

The rest of the catalogue, and why this language gets these, is in
[docs/katas](https://github.com/acodeninja/bootstrap/tree/main/docs/katas).

Delete this section when the project becomes real work.

## Licence

MIT — see [LICENSE](LICENSE).
