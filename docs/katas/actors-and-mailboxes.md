# Counter process

Spawn a process that holds a count. Send it messages to bump it, send it a message asking
what the count is, and have it answer. Then spawn a hundred of them and show that each has
its own count.

## What it teaches

That state lives in a process rather than in a variable, and the only way to reach it is a
message. The loop is a tail-recursive function taking the state as an argument and calling
itself with the next one — so "mutable state" is spelled as an argument, and nothing is
shared, and no lock exists because there is nothing to lock.

`receive` with a pattern per message is where the shape clicks. A hundred processes is
where the cost clicks: they are cheap in a way threads are not, which is the reason the
BEAM exists.

## Where it sits

Step 3 on `erlang`. It assumes FizzBuzz, and leads to
[turnstile](turnstile.md), which is this with the states named.

## Not available in

`elixir` runs on the same machine and could share this; it gets
[pattern-matched function heads](pattern-matched-function-heads.md) instead, so the two
BEAM rows teach different things. `pony` has actors and
[reference capabilities](reference-capabilities.md) in place of copying. `go` has
[channels](channels-and-select.md), which is the same instinct without the identity.

## Source

Written for this repo. Documented in
[Learn You Some Erlang: The Hitchhikers Guide to Concurrency](https://learnyousomeerlang.com/the-hitchhikers-guide-to-concurrency).
