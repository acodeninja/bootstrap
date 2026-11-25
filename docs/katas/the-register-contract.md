# Checksum

Sum the bytes of a NUL-terminated string and return the total. Then call it from a second
routine that has useful values in `r4` and `r5` and still has them afterwards.

## What it teaches

The calling convention, as a contract rather than a convention. Arguments arrive in `r0`
to `r3`, the answer leaves in `r0`, and `r4` upwards belong to the caller — so a routine
that wants them pushes them first and pops them last. Nothing enforces any of this. The
only thing that tells you it is broken is the wrong answer.

The second half of the lesson is the condition flags. There is no boolean type and nothing
raised: a comparison sets flags, a suffixed instruction reads them, and an `it` block is
how a branch yields a value without branching. That is the entire error channel too.

## Where it sits

Step 3 on `arm32`. It assumes [leap years](leap-years.md), because a string has no length
here and FizzBuzz is the harder of the two.

## Not available in

Nothing else here has registers. `c` is the nearest neighbour and has already abstracted
all of this away, which is a good thing to notice from below.

## Source

Written for this repo. The convention is specified in
[the Arm AAPCS](https://github.com/ARM-software/abi-aa/blob/main/aapcs32/aapcs32.rst).
