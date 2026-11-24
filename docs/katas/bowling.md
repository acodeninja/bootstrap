# Bowling

Score a game of ten-pin bowling from a valid sequence of rolls. A strike scores ten plus
the next two rolls, a spare ten plus the next one, and the tenth frame gets extra rolls
to make those bonuses land.

The scoring is the whole difficulty, and it is the first kata where the answer depends on
rolls you have not reached yet. Everything before this one walks a sequence forwards;
this one has to look ahead.

## What it teaches

Index arithmetic over a flat sequence, and lookahead — reading the next element, and the
one after, without losing your place. It needs no map, no set and no string, which is why
it suits every language with an array and nothing else.

## Where it sits

Step 4 on the Mainstream and Constrained tracks, step 3 on the Array and numeric and
Declarative tracks. It assumes FizzBuzz, and on the constrained rows Leap years before
it.

## Not available in

Nothing blocks it.

In `sql` it is the best kata in the catalogue — `lead` reads the following row without a
second pass (`templates/sql/files/tests/kitchen_sink.sql:101`), which is exactly what a
spare needs. In the array languages the frames are a segmentation problem rather than a
loop.

## Source

- [Made Tech: Bowling](https://learn.madetech.com/technology/katas/bowling/)
- [Coding Dojo: Bowling](https://codingdojo.org/kata/Bowling/)
- [Kata-Log: Bowling Game](https://kata-log.rocks/bowling-game-kata) — tagged Experienced
- Rules: [how points are determined in bowling](https://www.myactivesg.com/sports/bowling/how-to-play/bowling-rules/how-are-points-determined-in-bowling)
