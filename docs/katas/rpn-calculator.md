# RPN calculator

Evaluate reverse Polish notation: `3 4 +` is seven, `5 1 2 + 4 * + 3 -` is fourteen. Push
each number, and let each operator consume the operands below it.

For most languages this is a kata about implementing a stack. For a stack language it is
a kata about noticing you already have one — which is why it is the last step of the
Forth course and appears nowhere else.

## What it teaches

A stack as the working data structure, tokenising an expression, and the two failures
worth asserting: an operator with nothing underneath it, and a finished expression that
left more than one value behind.

## Where it sits

The last step of the `forth` course, in place of Roman numerals. It assumes Leap years.

## Not available in

Assigned to one row, so the question does not arise elsewhere. In `forth` itself the
language supplies the stack, the words and the execution tokens
(`templates/forth/files/tests/kitchen_sink.fs:72`) the dispatch needs.

## Source

- [Coding Dojo: RPN Calculator](https://codingdojo.org/kata/RPN/)
