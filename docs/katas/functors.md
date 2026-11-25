# Sorted bag

Write a module holding a sorted collection of items, parameterised over how its items
compare. Instantiate it twice from the same code: once for integers ascending, once for
strings by length.

## What it teaches

That a module can take a module as an argument. A signature says what the parameter has to
provide, a functor consumes one and produces a module, and the result is reuse without
generics, without inheritance and without anything resolved at run time. It is the oldest
good answer to the problem interfaces and traits were later invented for, and meeting it
after the others is instructive.

The smaller lesson is in the comparison: instantiating twice gives two *types* that cannot
be mixed up, where a generic class in most languages gives one type with a parameter.

## Where it sits

Step 3 on `ocaml`. It assumes FizzBuzz, and leads to
[word wrap](word-wrap.md) and [tennis](tennis.md).

## Not available in

Standard ML and `flix` have the nearest equivalents. `haskell` reaches the same place with
typeclasses, `scala` with [given instances](typeclasses-by-given.md), `rust` with traits —
all of which pass the capability rather than the module, which is the distinction to feel.

## Source

Written for this repo. Documented in
[Real World OCaml, Functors](https://dev.realworldocaml.org/functors.html).
