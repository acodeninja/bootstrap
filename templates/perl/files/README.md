# {{PROJECT_NAME}}

## Prerequisites

- **Docker**, with the daemon running
- **make** — on Windows, `winget install ezwinports.make`

You do not need Perl, perlcritic or perltidy. The toolchain lives in the
container, pinned by the `Dockerfile`, so a green suite here is a green suite
anywhere.

## Commands

```console
$ make test    # run the test suite
$ make lint    # perlcritic, then check every file is tidy
$ make fmt     # reformat in place
$ make build   # a no-op: Perl runs from source
$ make shell   # open a shell in the container
```

## Tests

`make test` is `prove -Isrc -r t`, so every `.t` file under `t/` runs and
nothing names them. Add a file and it is picked up; delete one and nothing
refers to it.

```perl
use Test::More;
use lib 'src';
use {{PROJECT_SNAKE}} qw(greet);

is(greet('world'), 'Hello, world!', 'a greeting addresses the name it is given');

done_testing();
```

`use lib 'src'` and `prove`'s `-Isrc` do the same job twice on purpose: the
flag is what `make test` relies on, and the line is what lets you run a single
file by hand with `perl t/whatever.t`.

`done_testing()` rather than a plan, because a count at the top of the file is
one more thing to update every time you add a case.

## Lint and formatting

`make lint` runs two checks that disagree about what they are for:

- **`perlcritic src t`** — Damian Conway's *Perl Best Practices* as rules. It
  objects to how the code is written, not how it is laid out.
- **`perltidy --assert-tidy`** — a real check mode, so lint needs no diffing of
  its own. `-se` keeps a complaint on stderr rather than writing a `.ERR` file
  into your project.

`make fmt` writes each file through a temporary file instead of using
perltidy's own `-b`. In-place mode sets the output file's permissions and
mtime, which a bind mount from a Windows host refuses — and perltidy treats
that refusal as a failure, so the formatter would fail on a file it had
already formatted correctly.

Both tasks glob inside the container, because perltidy takes files rather than
directories and the `Makefile` may not use host shell tools.

## Adding a dependency

There is no `cpanfile`: the image is the dependency manifest. Add the module to
the `Dockerfile` with a version, then `docker compose build`.

```dockerfile
RUN cpanm --quiet --notest JSON::MaybeXS@1.004008
```

If it is an XS module — anything that compiles C — it belongs in the `tools`
stage with the compiler instead, and the built module is copied forward. That
is the whole reason this `Dockerfile` has two stages: Perl::Critic's dependency
tree reaches Clone and Params::Util, which need `gcc` to build and nothing to
run.

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
