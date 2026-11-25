# Running total

A table of transactions with a date and an amount. Produce, for each row, the balance after
that transaction — and do it with no loop, no cursor and no variable, because the language
has none of those to offer.

Then produce each account's balance at its last transaction of the month, without a
subquery per account.

## What it teaches

Thinking in sets. The question is not "how do I walk these rows" but "what is true of each
row given the others", and a window function is how that gets said: `sum(...) over (order
by ...)` is the running total, and `row_number()` with a partition picks the last per group.

The second lesson is that iteration does exist here, and looks nothing like a loop: a
recursive CTE is the only unbounded repetition PostgreSQL has, and it carries no variable
at all. Writing one is the moment the declarative half of the language becomes a tool
rather than a restriction.

## Where it sits

Step 3 on `sql`. It assumes FizzBuzz — which here is a function returning text, because a
function is this template's unit of work — and leads to
[bowling](bowling.md) and [turnstile](turnstile.md).

## Not available in

`asp`, `prolog` and `mercury` are declarative too and solve rather than query.
[LINQ](query-over-a-sequence.md) was named after this and has no window functions. Every
imperative row would write the loop, which is the comparison worth making afterwards.

## Source

Written for this repo. Documented at
[PostgreSQL: Window Functions](https://www.postgresql.org/docs/current/tutorial-window.html)
and [WITH queries](https://www.postgresql.org/docs/current/queries-with.html).
