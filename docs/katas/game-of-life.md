# Game of Life

Conway's cellular automaton. Each cell on a grid is alive or dead; a live cell with two
or three live neighbours survives, a dead cell with exactly three comes to life, and
everything else dies or stays dead. Given one generation, produce the next.

Every cell is decided by the same arithmetic over its eight neighbours, which is why this
is the kata for a language built on whole-array operations: the version that loops over
cells and the version that shifts the whole grid eight ways and adds are the same
algorithm written in two different languages' worth of idiom.

## What it teaches

A two-dimensional grid, neighbour counting at the edges, and a generation computed from
the previous one rather than in place — the bug everyone writes first is updating a cell
that a later cell still needs to read.

## Where it sits

Step 4 on the Array and numeric track, and the last step for `bqn`. It assumes Bowling,
for the index arithmetic.

## Not available in

Nothing blocks it. It needs no strings at all, which is what makes it reachable where
most of the catalogue is not.

## Source

- [Coding Dojo: Game of life](https://codingdojo.org/kata/GameOfLife/)
- [Kata-Log: Game of Life](https://kata-log.rocks/game-of-life-kata) — tagged Experienced
