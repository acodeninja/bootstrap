# Hello, World

Print `Hello, World!`. That is the whole requirement, and it is not the point: the point
is that you now know how this language builds, where its entry point lives, how its test
runner finds a suite, and what a failing assertion looks like before you have any logic
worth debugging.

Do it twice. Once so the program prints it, and once so a function returns it and a test
asserts the return. The second is the one that matters — every kata after this one is
driven by a test, and this is the cheapest possible place to learn how this language's
runner reports red.

## What it teaches

The toolchain, not you. Build, run, output, and the first assertion you wrote rather than
read. On the fourteen rows whose runner is hand-rolled TAP rather than a framework, that
last part is a real skill and this is where to acquire it.

## Where it sits

Step 1 of every course, in all 64 languages. It assumes nothing.

## Not available in

Nothing blocks it.

Three rows have no stdout to print to, so only the second half applies: `elm` has no
terminal I/O at all, and in `asp` and `sql` the output of a program is an answer set and a
row. Write the function, assert the value.

## Source

- [Coding Dojo: Hello](https://codingdojo.org/kata/Hello/) — which also makes the case
  for separating the message from the thing that displays it
