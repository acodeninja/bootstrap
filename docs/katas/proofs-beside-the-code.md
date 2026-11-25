# Leap years, proved

Write the leap-year rule. Then write it a second time and differently — nested conditions
one way, divisibility arithmetic the other. Then prove the two agree.

Not test them. Prove them: one statement that they give the same answer for every year in
a range, accepted by the compiler, with no test cases chosen by you at all.

## What it teaches

That a theorem is an ordinary declaration in the same file as the function, and that
`decide` discharges one over a finite range with no tactic prose. It is the first time
most readers state a claim about *all* inputs rather than the dozen a suite happened to
pick, and the first time they watch a proof fail — which is more instructive than a test
failing, because the error names the case.

Start with a range. Proving it for every `Nat` is a different kata and a longer evening.

## Where it sits

Step 3 on `lean`. It assumes FizzBuzz, and [leap years](leap-years.md) for the rule.

## Not available in

Nothing else here can state the claim, let alone check it. `ats` and `koka` check
properties of memory and effects rather than of answers.

## Source

Written for this repo. The template ships no proof of any kind, so this is a first
exposure rather than reinforcement — which is the argument for it being step 3 rather
than something optional. Documented in
[Theorem Proving in Lean 4](https://leanprover.github.io/theorem_proving_in_lean4/).
