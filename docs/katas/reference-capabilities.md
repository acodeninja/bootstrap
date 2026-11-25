# Frozen roster

Build a roster of names, then hand the finished roster to two actors that each read it, at
the same time, with no copy and no lock.

The build and the read want different things. Building needs a mutable array; sharing it
across actors needs an immutable one; Pony will not let one value be both. The move from
one to the other is the kata.

## What it teaches

Reference capabilities — `iso`, `val`, `ref`, `box`, `tag` — and `recover`, which is the
door between them. A capability is part of the type, so "who may write this, and who may
see it" is checked when you compile rather than hoped for when you run. That check is why
Pony needs no locks, and this is the smallest problem where the absent lock is visible
rather than theoretical.

## Where it sits

Step 3 on `pony`. It assumes FizzBuzz.

## Not available in

`erlang` and `elixir` reach the same safety by copying every message, which costs nothing
to learn and something to run. Nothing else here checks aliasing at all.

## Source

Written for this repo. The feature is documented in
[the Pony tutorial](https://tutorial.ponylang.io/reference-capabilities/).
