# {{PROJECT_NAME}}

## Prerequisites

- **Docker**, with the daemon running
- **make** — on Windows, `winget install ezwinports.make`

You do not need GNAT. The toolchain lives in the container, pinned by the
`Dockerfile`, so a green suite here is a green suite anywhere.

## Commands

```console
$ make test    # run the test suite
$ make lint    # check every unit, warnings as errors
$ make fmt     # a no-op: Debian ships no gnatpp
$ make build   # compile the project into /cache
$ make shell   # open a shell in the container
```

## Tests

Every file under `tests/` is a whole program. It declares its fixture, its test
procedures and its suite inside one procedure body, then runs them:

```ada
procedure Greet_Suite is
   type Fixture is new AUnit.Test_Fixtures.Test_Fixture with null record;
   package Caller is new AUnit.Test_Caller (Fixture);
   ...
   function Run is new AUnit.Run.Test_Runner_With_Status (Suite);
begin
   if Run (Reporter) /= AUnit.Success then
      Ada.Command_Line.Set_Exit_Status (Ada.Command_Line.Failure);
   end if;
end Greet_Suite;
```

That shape is deliberate. A package would need a spec beside the body, so
deleting one test would mean deleting two files and the project would not
compile until you had found both. One procedure body is a complete compilation
unit on its own, which keeps a test to a single file — and it means nothing has
to be generated to find them: `make test` hands each `tests/*.adb` to
`gprbuild` as a main, one at a time.

Add a file to `tests/` and it is picked up; delete one and nothing refers to
it.

`Test_Runner_With_Status` is what makes a failure visible to `make`: the plain
`Test_Runner` prints its report and exits zero regardless.

## Lint

`make lint` is `gprbuild -c` with `-gnatc`, so it checks without generating
code, and `-gnatwae`, so every warning is an error. Ada's front end says most
of what a linter elsewhere would — a missing case arm, a type mismatch, a
variable that is never modified.

Two switches earn their place:

- **`-f`** forces recompilation. `gprbuild` is incremental and `make test`
  compiles the same sources with different switches, so without it lint reuses
  objects that were never checked and passes by saying nothing.
- **`-gnatwC`** drops "condition is always True". A suite asserts things the
  compiler can often prove, and that is a fact about tests rather than a fault
  in them.

## There is no formatter

`gnatpp` is not packaged in Debian; it ships with AdaCore's own distribution.
So `make fmt` says so and does nothing, and `.editorconfig` is what keeps the
layout honest — three spaces, which is what GNAT's own style checks expect.

## Adding a dependency

`{{PROJECT_SNAKE}}.gpr` is the project file. A library installed in the image
is added by withing its project:

```ada
with "aunit";
with "gnatcoll";
```

`apt-cache search 'libada\|^lib.*-dev' | grep -i ada` lists what Debian has.
Install it in the `Dockerfile`, then `with` it here and run
`docker compose build`.

Objects and executables go to `/cache`, not into your project, which is why
`make build` leaves the tree clean and a second run is quick.

## CI

`.github/workflows/ci.yml` builds the image and runs lint and tests on every
push, and needs no secrets to do it.

`DOCKERHUB_USERNAME` and `DOCKERHUB_TOKEN` are optional, and worth setting only
if the build starts failing to pull its base image: Docker Hub rate-limits
anonymous pulls and GitHub's runners share IP addresses, so the error looks
nothing like the real cause.

## Course

Three katas, in this order, each introducing one thing the last one did not:

1. [Hello, World](https://github.com/acodeninja/bootstrap/blob/main/docs/katas/hello-world.md) — the toolchain, not you, and already solved beside this file
2. [FizzBuzz](https://github.com/acodeninja/bootstrap/blob/main/docs/katas/fizzbuzz.md) — a loop, a branch, and your first test
3. [Percentage, enforced twice](https://github.com/acodeninja/bootstrap/blob/main/docs/katas/subtypes-and-contracts.md) — a range in the type, enforced twice

Then, when the group wants more: [Roman numerals](https://github.com/acodeninja/bootstrap/blob/main/docs/katas/roman-numerals.md) → [Number to LCD](https://github.com/acodeninja/bootstrap/blob/main/docs/katas/number-to-lcd.md) → [Mars Rover](https://github.com/acodeninja/bootstrap/blob/main/docs/katas/mars-rover.md).

The rest of the catalogue, and why this language gets these, is in
[docs/katas](https://github.com/acodeninja/bootstrap/tree/main/docs/katas).

Delete this section when the project becomes real work.

## Licence

MIT — see [LICENSE](LICENSE).
