# First to answer

Ask two workers the same question. Each takes a different, unpredictable amount of time.
Take whichever answer arrives first, ignore the other, and make sure nothing is left
running when you return.

Then add a deadline, so that if neither answers in time you say so.

## What it teaches

That concurrency here is a language feature rather than a library: `go` starts the work, a
channel carries the answer, and `select` takes whichever case is ready. The deadline is one
more case, which is the moment the design clicks — a timeout is not special.

The second half is the part people get wrong in production. The loser is still running, and
its channel send will block forever if nobody reads it, so a goroutine leaks. Fixing that
with a buffered channel or a cancelled context is the actual lesson, and it is the reason
this is Go step 3 rather than a party trick.

## Where it sits

Step 3 on `go`. It assumes FizzBuzz, and leads to
[roman numerals](roman-numerals.md) and [bowling](bowling.md).

## Not available in

`erlang`, `elixir` and `pony` have [actors](actors-and-mailboxes.md), where the thing you
address has an identity; a channel does not, which is the distinction worth feeling. The
kitchen sink keeps concurrency out of every template on purpose, so this is the one place
in this repo where anything runs at the same time as anything else.

## Source

Written for this repo. Documented at
[Go by Example: Select](https://gobyexample.com/select) and
[Go Concurrency Patterns](https://go.dev/blog/pipelines).
