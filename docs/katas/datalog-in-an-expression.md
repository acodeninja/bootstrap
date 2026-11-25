# Who reports to whom

Given a list of who manages whom directly, answer who is in somebody's reporting chain at
any depth. Then do it as an ordinary function that an ordinary test calls.

## What it teaches

That a Datalog program can be a value. The rules are written inside a function, the facts
come from its arguments, and the query hands back a result the rest of your code uses — so
transitive closure stops being a graph algorithm you implement and becomes two rules you
state. This is the one thing in this repo that puts a solver inside a function.

The second lesson is the company it keeps. Flix is a functional language with an effect
system, so the same file does exhaustive matching, `Result`, and region-scoped mutation
that leaves the function pure. Writing the recursive rule next to a hand-written recursion
is how the comparison lands.

## Where it sits

Step 3 on `flix`. It assumes FizzBuzz.

## Not available in

`prolog`, `mercury` and `asp` all compute transitive closure and none of them can return
it to a caller in another paradigm — the program *is* the logic program. That difference is
why `flix` is a fourth logic row rather than a duplicate.

## Source

Written for this repo. Documented at
[Flix: Datalog](https://doc.flix.dev/fixpoints.html).
