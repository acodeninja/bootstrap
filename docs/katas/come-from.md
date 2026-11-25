# Countdown

Count down from a number to zero, and do the looping with `COME FROM` rather than with a
jump you wrote on purpose.

## What it teaches

Control flow that reads backwards. A `COME FROM` sits at the destination and names the line
that will arrive there, so the line doing the jumping contains no evidence that anything
jumps — the reader has to search the file to find out where a statement goes next. It is
the inverse of `GOTO`, and it was invented as a joke that turned out to be instructive.

The rest of the vocabulary comes with it: `DO ... NEXT` pushes a return address, `RESUME`
pops as many as you tell it, and `FORGET` discards one so a later `RESUME` lands further
out than you would expect. There is no call stack to reason about other than this.

## Where it sits

Step 3 on `intercal`. It assumes [leap years](leap-years.md), because INTERCAL has no
division operator and FizzBuzz is the longer job.

## Not available in

Nothing. `basic` has the nearest relative in
[computed GOSUB](computed-gosub.md) — a jump whose target you compute — which is strange
in the opposite direction.

## Source

Written for this repo. Specified in
[the INTERCAL reference manual](https://3e8.org/pub/intercal.pdf), under COME FROM.
