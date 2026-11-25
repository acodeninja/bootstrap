# A fair bit, and a pair that agree

Prepare one qubit so that measuring it gives zero or one with equal probability, and
measure it a thousand times to convince yourself. Then prepare two qubits so that neither
outcome is predictable alone and the two always match.

Then undo an operation without writing its inverse.

## What it teaches

That a quantum program is a sequence of reversible operations on registers, and that
measurement is the irreversible part at the end. `H` puts a qubit in superposition, a
controlled `X` entangles two, and the second half of the problem is the one that cannot be
explained by either qubit having a secret value decided in advance.

The third clause teaches the `Adjoint` functor: an operation declared `is Adj` can be run
backwards by the compiler, which is a kind of code reuse nothing else in this repo has.

## Where it sits

Step 3 on `qsharp`. It assumes [leap years](leap-years.md) — there is no string type here,
so FizzBuzz is the longer job — and leads to [turnstile](turnstile.md).

## Not available in

Nothing else here, obviously. What transfers in the other direction is worth knowing
before you start: Q# has no map, no set, no string length or split, and no exceptions or
`Result`, so a refusal comes back as a tuple. The array is the only collection.

## Source

Written for this repo. Documented at
[Q#: Quantum entanglement tutorial](https://learn.microsoft.com/en-us/azure/quantum/tutorial-qdk-explore-entanglement).
