# Top scorers

A list of results, each with a player, a game and a score. In one expression: drop the
unfinished games, group by player, total each player, order by the total descending, and
take the top three with their rank.

Then do it again as a loop, and keep whichever you would rather read in a year.

## What it teaches

Query as a first-class thing rather than a loop you wrote. `Select`, `Where`, `GroupBy`,
`OrderBy` and `Aggregate` compose into one expression, deferred until something reads it,
and the lambda is an ordinary value with a type you can name — which is the bit worth
dwelling on, because `Func(Of Integer, Integer)` makes explicit what `=>` hides.

Visual Basic adds a reason to care: it has the query *syntax* as well as the method chain,
so the same question can be written two ways in one language and compared side by side.

## Where it sits

Step 3 on `csharp` and `visualbasic`. It assumes FizzBuzz, and leads to
[roman numerals](roman-numerals.md) and [bowling](bowling.md).

## Not available in

`java` streams, `kotlin` and `swift` sequence operators, `ruby` Enumerable, `rust`
iterators and `python` comprehensions all answer the same question. `sql` answers it
[without a loop existing at all](set-at-a-time.md), which is the comparison that makes
LINQ make sense: it was named after the one it borrowed from.

## Source

Written for this repo. Documented at
[LINQ](https://learn.microsoft.com/en-us/dotnet/csharp/linq/).
