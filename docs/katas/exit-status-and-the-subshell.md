# Tally the lines

Count how many lines of a file match a pattern, into a shell variable the caller can still
read afterwards. Write it the obvious way first — a loop in a pipeline — and watch the
count come back zero.

Then make the function refuse an unreadable file, and have the caller tell the difference
between a refusal and a count of nothing.

## What it teaches

The two things about bash that bite hardest, and they are both about boundaries. A loop on
the right of a pipe runs in a subshell, so the variable it incremented is a variable in a
process that has exited — and the fix is to get rid of the pipe, not to try harder.

The second is that a function has no return value. There is a numeric exit status and
there is whatever it printed, and those are different channels: a refusal is a non-zero
status, which is why the suite reaches for `run` and reads `$status` rather than comparing
output. Distinguishing "no matches" from "could not look" is the whole exercise.

## Where it sits

Step 3 on `bash`. It assumes FizzBuzz, and leads to
[word wrap](word-wrap.md) and [string calculator](string-calculator.md).

## Not available in

`powershell` has [an object pipeline](the-object-pipeline.md) and no subshell surprise,
which is the comparison to draw. Every other row has functions that return values, and
nothing else here makes a process boundary invisible in the middle of a one-line
expression.

## Source

Written for this repo. Documented in
[the Bash manual](https://www.gnu.org/software/bash/manual/bash.html#Pipelines) and
[BashFAQ 024](https://mywiki.wooledge.org/BashFAQ/024).
