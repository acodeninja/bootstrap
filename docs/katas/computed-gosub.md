# Dispatch table

Classify a number as negative, zero or positive, and pick the handler by computing which
one to call rather than by testing each case in turn. Then add a fourth class without
touching the dispatch.

## What it teaches

`ON expression GOSUB` — a jump whose destination is an index into a list of line numbers,
which is a dispatch table with the serial numbers filed off. Getting the arithmetic to
line up with the list is the exercise, and an off-by-one sends control somewhere that
still runs.

It also teaches the shape of a program with no local variables. A subroutine shares every
variable with its caller, so the calling convention is a habit: which names hold the
arguments, which hold the answer, and a layout that keeps the subroutines out of the way
of the line numbers you are still using.

## Where it sits

Step 3 on `basic`. It assumes FizzBuzz.

## Not available in

Nothing here is quite this. A lookup table of functions in `lua`, `javascript` or `python`
is the same idea with names instead of line numbers, and is worth writing next to this one.

## Source

Written for this repo. `ON ... GOSUB` is documented in
[the Bywater BASIC manual](https://sourceforge.net/projects/bwbasic/).
