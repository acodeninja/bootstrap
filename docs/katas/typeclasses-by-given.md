# Describe anything

Write one function that renders a short description of a value — any value — provided
somebody has said how that type describes itself. Make it work for integers and strings,
then for a type of your own, then for a list of anything describable, without changing the
function.

## What it teaches

Typeclasses, spelled as `trait` plus `given` plus `using`. The capability travels separately
from the type, so you can describe a type you do not own; and the instance for `List[A]` is
derived from the instance for `A`, which is where the idea stops looking like an interface
and starts looking like something else.

The discipline is knowing when the implicit search has found something you did not mean. An
ambiguous `given` is a compile error worth reading carefully, and it is the reason Scala 3
renamed all of this.

## Where it sits

Step 3 on `scala`. It assumes FizzBuzz, and leads to
[tennis](tennis.md) and [turnstile](turnstile.md).

## Not available in

`haskell` has the original and gets [laziness](laziness.md) instead. `rust` traits are the
same idea with coherence enforced, `ocaml` passes
[a module](functors.md) rather than an instance, and `swift` protocols with extensions get
close. Interfaces in `java`, `go` and `csharp` cannot do the last clause: you may not add
a conformance to a type you did not write.

## Source

Written for this repo. Documented at
[Scala 3: Given Instances](https://docs.scala-lang.org/scala3/book/ca-given-using-clauses.html).
