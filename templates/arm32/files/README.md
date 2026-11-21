# {{PROJECT_NAME}}

## Prerequisites

- **Docker**, with the daemon running
- **make** — on Windows, `winget install ezwinports.make`

You do not need an ARM toolchain or an ARM machine. The assembler, linker and
emulator all live in the container, pinned by the `Dockerfile`.

## Commands

```console
$ make test    # boot each test on an emulated Cortex-M3
$ make lint    # assemble every file, warnings as errors
$ make fmt     # a no-op: ARM assembly has no formatter
$ make build   # assemble the project into /cache
$ make shell   # open a shell in the container
```

## What is actually running

There is no operating system. `make test` assembles each test together with
`src/`, links it with `{{PROJECT_SNAKE}}.ld` into a firmware image, and boots
that image on **QEMU's MPS2 AN385** — an ARM development board with a Cortex-M3
— one test at a time.

A test reaches the outside world through **ARM semihosting**: `bkpt 0xAB` with
an operation in `r0` asks the emulator to do something on the host's behalf.
`src/start.S` uses two of those operations, `SYS_WRITE0` to print and
`SYS_EXIT` to stop the machine. That is the whole of this project's I/O.

## Tests

Every `.S` file under `tests/` is a whole firmware image that prints
[TAP](https://testanything.org/). `src/start.S` supplies the vector table and
the reset handler; a test supplies `main`:

```asm
        .thumb_func
        .global main
main:
        push    {lr}
        ldr     r0, =plan_s
        bl      puts

        movs    r0, #21
        bl      double
        movs    r1, #42
        ldr     r2, =case1
        bl      report_eq

        pop     {pc}
```

`report_eq` compares `r0` against `r1` and prints one TAP line, taking the
name from `r2`. Add a file to `tests/` and it is booted; delete one and
nothing refers to it.

**Two things the runner catches that nothing else would.** A plan line that
does not match the number of results means the image stopped part way
through — there is no exception to propagate and no exit status to read. And
every image runs under a ten-second `timeout`, because assembly's
characteristic failure is a branch to itself, and a chip spinning forever
reports nothing at all.

## Lint

`make lint` assembles every file with `--fatal-warnings` and throws the object
away. At this level that is a real check: a mnemonic that does not exist, a
register a Cortex-M does not have, or ARM encoding where Thumb was meant all
fail here rather than at run time.

## There is no formatter

No ARM assembly formatter exists. `make fmt` says so and does nothing, and
`.editorconfig` carries the eight-column layout the files use instead.

## The memory map is yours

`{{PROJECT_SNAKE}}.ld` says where code and data land, and it is in the project
rather than the image so that changing it does not mean rebuilding a container.
The `KEEP` around `.vectors` is load-bearing: nothing references the vector
table by name, and the linker would otherwise discard the one thing the chip
needs at address zero.

To emulate a different board, change `-M` in the image's `arm32-run` and the
`MEMORY` block here to match. `qemu-system-arm -M help` lists what is
available.

## CI

`.github/workflows/ci.yml` builds the image and runs lint and tests on every
push, and needs no secrets to do it.

`DOCKERHUB_USERNAME` and `DOCKERHUB_TOKEN` are optional, and worth setting only
if the build starts failing to pull its base image: Docker Hub rate-limits
anonymous pulls and GitHub's runners share IP addresses, so the error looks
nothing like the real cause.

## Licence

MIT — see [LICENSE](LICENSE).
