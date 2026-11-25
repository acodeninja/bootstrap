# Seating

Four people sit in a row. Ana will not sit next to Ben. Cleo insists on an end. Dai must be
somewhere to the left of Ana. Write down what a legal seating is, and let the language find
all of them.

## What it teaches

That you can describe the answer instead of computing it. There is no loop and no search in
what you write: unification binds, failure backtracks, and `findall/3` collects what
survives. The shift is in whose job the search is.

Two distinctions earn their keep here. `=` unifies and `is/2` evaluates, so a sum written
with `=` stays a term and is never added up. And a predicate with no answer simply fails —
there is nothing raised, which is the language's entire refusal idiom.

## Where it sits

Step 3 on `prolog`. It assumes FizzBuzz, and leads to
[eight queens](eight-queens.md), which is this kata with a bigger board.

## Not available in

`mercury` can do it and will insist you declare the modes — that is
[its own step 3](modes-and-determinism.md). `asp` does it by
[finding models](choice-rules.md) rather than by resolving, which is a different mechanism
reaching the same place. Everywhere else, you write the search yourself.

## Source

Written for this repo, as the smallest version of a shape
[eight queens](eight-queens.md) scales up. Documented in
[the SWI-Prolog manual](https://www.swi-prolog.org/pldoc/man?section=findall).
