# Receipt

Build a receipt: a header line, one line per item, and a total. Return it as one string.

In most languages that is a fold. Here every intermediate string is linear — owned by
exactly one place, consumed exactly once — and the typechecker refuses the program if one
is dropped or used twice. A loop that concatenates is therefore a loop that frees, and
writing it is the exercise.

## What it teaches

Linear types, and what a proof of memory safety costs when nobody is counting references
for you. `Strptr1` in a return type is a promise the caller has to keep, and `~` in a
pattern is where the obligation discharges. The surprise is that the typechecker, not a
crash, is what tells you the obligation is still outstanding.

It also makes the other proof rows legible. `koka` counts references, `lean` traces, and
`ats` hands you the free: three answers to one question, and this is how the question
becomes a thing you can see.

## Where it sits

Step 3 on `ats`. It assumes FizzBuzz.

## Not available in

Nothing else here frees by hand under a typechecker that enforces it. `c` frees by hand
with nothing enforcing it, which is the comparison worth making afterwards.

## Source

Written for this repo. The feature is documented in
[Introduction to Programming in ATS](http://www.ats-lang.org/DOCUMENT/INT2PROGINATS/HTML/book1.html),
under linear types and dataviewtypes.
