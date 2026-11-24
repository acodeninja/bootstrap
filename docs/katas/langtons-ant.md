# Langton's Ant

An ant sits on a grid of coloured squares. On white it turns right, paints the square
black and steps forward; on black it turns left, paints the square red and steps forward;
on red it does not turn, paints the square white and steps forward. Run it and watch what
comes out.

Three rules, no strings, no input, and a grid that is both the state and the output. For a
language whose program *is* a two-dimensional grid of cells it can read and write, this is
the kata that fits and most of the catalogue is not.

## What it teaches

A grid you mutate as you walk it, a direction that turns, and a state machine whose next
move depends only on where it is standing. The deterministic answer after a fixed number
of steps is what the test asserts.

## Where it sits

The last step of the `befunge` course. It assumes FizzBuzz.

## Not available in

Assigned to one row. Nothing stops any other language doing it, and it is a reasonable
alternative to Game of Life wherever a grid is wanted.

## Source

- [Coding Dojo: Langton Ant](https://codingdojo.org/kata/LangtonAnt/) — the three-colour
  version described above; the original two-colour rules are a simpler start
