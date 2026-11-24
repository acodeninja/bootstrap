# Turnstile

Model a turnstile as a finite state machine. It is locked or unlocked; a coin and a push
are the two events; and each state–event pair names both the state to move to and the
thing to do on the way — unlock, lock, sound the alarm, or say thank you.

Four transitions is small enough to finish in a sitting and complete enough to be a real
state machine, including the two cases people forget: a coin in an already-unlocked
turnstile, and a push on a locked one.

## What it teaches

An exhaustive match on a state enum, and a transition that carries an action. It is the
first kata where the state is the design rather than a variable, and in a language with
actors or effect handlers it is where those arrive.

## Where it sits

Step 5 on the Pattern matching track, step 3 on the Declarative track, and step 4 for
`koka`, `qsharp` and `sql`. It assumes Tennis on the pattern-matching rows, because the
closed set of states is the same idea twice.

## Not available in

Nothing blocks the machine itself.

The rows with no first-class functions — `befunge`, `sql`, `lolcode`, `basic`, `intercal`,
`asp` — cannot hand the action to the transition as a callback, so the dispatch is a
branch. The kata still works, and the difference is worth noticing rather than avoiding.

## Source

- [Made Tech: Turnstile](https://learn.madetech.com/technology/katas/turnstile/), which
  has a [part 2](https://learn.madetech.com/technology/katas/turnstile/part2.html) — do
  not read it until part 1 passes
- State diagrams on that page are drawn with [yUML](https://yuml.me)
