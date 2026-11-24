# Diamond

Given a letter, print a diamond: `A` at the top and bottom, the given letter at the
widest point, each letter on both sides of its row, and the whole thing symmetrical in
both directions.

Two symmetries and an off-by-one in the middle row, and the output is wrong in a way you
can see rather than one you have to reason about — which makes it a good place to learn
how this language compares multi-line strings in a test.

## What it teaches

String repeat, padding and join, and building an output whose shape is the requirement.
It is the second half of what Number to LCD teaches, without the digit table.

## Where it sits

The last step on the Array and numeric and Text processing tracks. It assumes Game of
Life or String calculator before it.

## Not available in

The five rows with no usable string handling: `lolcode`, `intercal`, `befunge`, `qsharp`,
`asp`.

## Source

- [Coding Dojo: Diamond](https://codingdojo.org/kata/Diamond/)
- [Emily Bache: DiamondKata](https://github.com/emilybache/DiamondKata) — test cases, and
  a comparison of the iterative and incremental routes to it
