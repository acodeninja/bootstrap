# Turn

A dial has four positions. Write the function that turns it one step, as four function
clauses with no branch inside any of them. Then add a guard so that turning past a limit
refuses, and a `!` variant that raises where the first returns a tagged tuple.

## What it teaches

That the branch belongs in the head. One name, several clauses, the clause chosen by the
pattern and guard rather than by a `case` inside one body — which is a different way to
think about a function, not a tidier spelling of the same one. Adding a position means
adding a clause and touching nothing.

The second half is the failure idiom the whole ecosystem is built on: `{:ok, value}` and
`{:error, reason}` from the ordinary function, and a `!`-suffixed twin that raises for
callers who would rather not match. Writing both for one function is how the convention
stops being arbitrary.

## Where it sits

Step 3 on `elixir`. It assumes FizzBuzz, and leads to
[tennis](tennis.md) and [turnstile](turnstile.md).

## Not available in

`erlang` has clause heads too and gets [actors](actors-and-mailboxes.md) instead, so the
two BEAM rows differ on purpose. `haskell`, `ocaml`, `gleam`, `rust` and `elm` all match
in a head or an equation and none of them has the `!` convention. The imperative rows have
neither.

## Source

Written for this repo, because the template's kitchen sink matches inside a `case` and
never in a head — the one idiom a reader of that file would not meet. Documented at
[Elixir: Pattern matching](https://hexdocs.pm/elixir/pattern-matching.html).
