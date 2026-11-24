# Mars Rover

Drive a rover around a grid. It starts at a position and a compass direction, and takes a
string of commands: turn left, turn right, move forward, move back. The grid wraps at the
edges. Obstacles stop the rover where it stands, and it reports what happened without
losing the ground it covered.

It is the capstone of the mainstream courses because it is the first kata that needs
everything at once: a record for the position, a closed set for the direction, modulo
arithmetic for the wrap, a parse of the command string, and a failure that is reported
rather than thrown away.

## What it teaches

Records and enums together, modulo arithmetic, parsing a command string, and the
language's own idiom for refusing — the obstacle case is where you find out whether this
language returns errors or raises them. The Made Tech brief is pointed about it: losing a
rover to an overlooked null is not an acceptable outcome.

## Where it sits

Step 5 on the Mainstream, Systems and Text processing tracks — the last step of each. It
assumes Bowling or Number to LCD before it.

## Not available in

The rows that cannot parse the command string: `intercal` and `befunge` (no strings),
`lolcode` (no character access), `qsharp` (no string index — take the commands as an
array instead). No course assigns it to those rows.

## Source

- [Made Tech: Mars Rover](https://learn.madetech.com/technology/katas/mars-rover/)
- [Coding Dojo: Mars Rover](https://codingdojo.org/kata/mars-rover/)
- [Kata-Log: Mars Rover](https://kata-log.rocks/mars-rover-kata) — tagged Experienced
- [Victor Farcic's walkthrough](https://technologyconversations.com/2014/10/17/java-tutorial-through-katas-mars-rover/)
  — a solution, so leave it until afterwards
