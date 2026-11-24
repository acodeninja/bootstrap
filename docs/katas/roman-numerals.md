# Roman numerals

Convert an integer to Roman numerals: 1 is `I`, 4 is `IV`, 1994 is `MCMXCIV`. Take it as
far as the language makes comfortable, and in the hardest rows take the additive cases
only.

The first kata that needs a lookup table in a particular order, and the first where the
answer is a string you built rather than one you printed. Those two together are most of
what the rest of the catalogue assumes.

## What it teaches

An ordered table, a loop that consumes a value as it goes, and string building. Subtractive
pairs are a second pass over the same structure, which makes it a kata you can stop
halfway through and still have something that passes.

## Where it sits

Step 3 on the Mainstream, Systems and Message passing tracks, step 4 on the Lisp,
Constrained and Proof and effects tracks. It assumes FizzBuzz.

## Not available in

- `asp` — a string is one opaque term, and building one means leaving the language for a
  Lua `@`-term (`templates/asp/files/tests/kitchen_sink.lp:54`). The declarative rows do
  Turnstile and Eight Queens instead.
- `befunge` — no strings, only character codes on a stack.

In `intercal` the opposite is true: `READ OUT` already prints its numbers as Roman
numerals, so the output half comes free.

## Source

- [Made Tech: Roman numerals](https://learn.madetech.com/technology/katas/roman-numerals/)
- [Coding Dojo: Roman Numerals](https://codingdojo.org/kata/RomanNumerals/)
- [Kata-Log: Roman Numerals](https://kata-log.rocks/roman-numerals-kata) — tagged Starter
- Rules: [Roman numerals](https://en.wikipedia.org/wiki/Roman_numerals)
