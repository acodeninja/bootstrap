# {{PROJECT_NAME}}

## Prerequisites

- **Docker**, with the daemon running
- **make** — on Windows, `winget install ezwinports.make`

You do not need Haxe. The toolchain lives in the container, pinned by the
`Dockerfile`, so a green suite here is a green suite anywhere.

## Commands

```console
$ make test    # run the test suite
$ make lint    # typecheck every module and check formatting
$ make fmt     # reformat in place
$ make build   # typecheck the library on its own
$ make shell   # open a shell in the container
```

## Tests

Tests are [utest](https://github.com/haxe-utest/utest) classes: implement
`utest.ITest`, give the class a constructor, and every method named `test…` is a
test. There is no registration — a build macro reads the class and finds them.

What utest cannot do is find the *classes*, so `make test` generates a runner
that names them from whatever is in `test/`. Add a file there and it joins the
suite; delete one and it stops being looked for. The compiler flags live in
`test.hxml` rather than in the image, so you can change them without a rebuild.

Test classes sit at the top of `test/` with no package, because the generated
runner names them unqualified.

## There is nothing to build

`make test` and `make build` both run the compiler against the **eval** target,
which is the interpreter built into `haxe` itself. It produces no file, so there
is no artefact to keep and no second runtime to install — the image carries
neither Node nor a JVM.

That makes `make build` a typecheck of `src/` on its own, and `make lint` a
typecheck of `src/` and `test/` together with `--no-output`, followed by the
formatter in check mode. A type error fails both.

Cross-compiling is what Haxe is famous for and this project does none of it. Add
`--js build/app.js` or `--cpp build` to an `.hxml` when you want a target; the
compiler already has them.

## Adding a dependency

Libraries come from haxelib, installed into `/cache/haxelib` when the image is
built so that no test run touches the network. Add a line beside the two that are
there, pin the version, and `docker compose build`:

```dockerfile
RUN haxelib --never install thx.core 0.44.0
```

Then name it in `test.hxml` or `build.hxml` with `-lib thx.core`.

Installing a library from inside the container instead works until the cache
volume is recreated, which makes it the wrong place to keep one.

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
