# Snake

The Nokia game. A snake crosses a wrapping grid, turns when told, grows when it eats, and
dies when it runs into itself. A 180-degree turn is not allowed, because the snake cannot
reverse into its own neck.

## What it teaches

Mutable state over time, a deque for the body, and a record plus a direction enum for the
head. It is the only kata in the catalogue whose subject is a loop that keeps running.

## Where it sits

**No course uses it, and no course can.** It needs an input loop and a render path, and
`docs/kitchen-sink.md:93` keeps I/O out of every template on purpose: the suite covers
only what the katas need, and nothing else here needs a keyboard.

Make it testable and it comes back: feed the game a list of moves, assert the board that
comes out, and the interactive part is gone along with the obstacle. That is worth doing
once the rest of a course is behind you.

## Not available in

Interactively, almost nowhere. `elm` is blocked twice over — no terminal I/O at all, and
no browser target in this repo for the version it is usually written as.

## Source

- [Made Tech: Snake](https://learn.madetech.com/technology/katas/snake/)
- Rules: [Snake on the Nokia wiki](https://nokia.fandom.com/wiki/Snake) and
  [the genre](https://en.wikipedia.org/wiki/Snake_(video_game_genre))
