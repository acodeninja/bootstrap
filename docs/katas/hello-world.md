# Hello, World

Write a function that returns `Hello, World!`, and a test that asserts it does. That is
the whole requirement, and it is not the point: the point is that you now know how this
language declares a function, how its test runner finds a suite, how a test is named, and
what a failing assertion looks like before you have any logic worth debugging.

**A function and a test, not a program that prints.** Printing is the version of this kata
everybody has met, and it teaches the least transferable thing in the language — every
kata after this one is driven by a test, and nothing after this one prints. Three rows have
no terminal to print to at all (`elm` has no I/O, and in `asp` and `sql` the output of a
program is an answer set and a row), so the printing version was never true for all 64.
The returning version is.

## The answer already ships

You do not start from nothing. Every generated project carries this kata solved, in its
`src/` module and its test, and both are **heavily commented** for exactly this step — see
[greeter.md](../greeter.md) for what those comments are allowed to say. Read them, run
`make test`, then break the assertion on purpose so you have seen this runner report red.

Then do it again without looking: a second function, a second test, your own names.
Writing the second one is the step that moves the knowledge from the page into your hands,
and it is cheap here in a way it never is again.

## What it teaches

The toolchain, not you. A declaration, an export, a test the runner discovers, a name that
reads on its own, one assertion, and `make test`. On the fourteen rows whose runner is
hand-rolled TAP rather than a framework, adding an assertion means editing the plan line
that counts them, and learning that is a real skill — this is where to acquire it.

## Where it sits

Step 1 of every course, in all 64 languages. It assumes nothing.

## Not available in

Nothing blocks it, now that the requirement is a returned value rather than a printed line.

Six rows cannot hold the ordinary greeter and ship the nearest thing their language has
instead: `asp` derives an atom, `befunge` prints because it has no callable anything,
`intercal` answers through a shared variable, `qsharp` writes an integer into a qubit
register because it has no string type, `sql` ships a function because a function is its
unit of work, and `octave` names the function after the file because it has to.
[greeter.md](../greeter.md#where-a-language-has-no-greeter) says why for each.

## Source

- [Coding Dojo: Hello](https://codingdojo.org/kata/Hello/) — which also makes the case for
  separating the message from the thing that displays it, and this is that case taken to
  its end: there is no thing that displays it
