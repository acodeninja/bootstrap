# Tennis

Score a single game of tennis. Points run love, fifteen, thirty, forty; at forty–forty it
is deuce; from deuce a player needs advantage and then two clear points to win.

Every case is a branch and none of them needs a data structure, which makes it the kata
for a language whose argument is its type system: the states are a closed set, the
transitions between them are total, and a compiler that checks you covered every case
will tell you so.

## What it teaches

A fixed set of named states, and a branch that yields a value. In a language with sum
types and exhaustive matching this is where that pays off; in one without, it is where
you find out what the absence costs.

## Where it sits

Step 4 on the Pattern matching and Message passing tracks, and the last step for `lean`
and `ats`. It assumes Word wrap or Roman numerals before it, for the string handling the
score names need.

## Not available in

Nothing blocks it.

## Source

- [Made Tech: Tennis](https://learn.madetech.com/technology/katas/tennis/) — which scores
  it by Wii Tennis rules, one game per set
- [Coding Dojo: Tennis](https://codingdojo.org/kata/Tennis/)
- [Kata-Log: Tennis](https://kata-log.rocks/tennis-kata) — tagged Starter
