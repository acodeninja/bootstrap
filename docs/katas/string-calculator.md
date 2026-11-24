# String calculator

Add the numbers in a string. An empty string is zero, `"1,2"` is three, and then the
requirements keep arriving: any count of numbers, newlines as well as commas, a custom
delimiter declared on the first line, negatives refused by name, and every error reported
at once rather than one at a time.

It is the kata for a language whose job is text, and the one that most rewards taking the
requirements strictly in order: each new rule is a few lines if the last one left the code
tidy, and a rewrite if it did not.

## What it teaches

Splitting on more than one separator, parsing numbers out of text, and accumulating
several failures instead of stopping at the first — which is the error-handling idiom
this repo's kitchen sink only has one slot for.

## Where it sits

Step 4 on the Text processing track, and the last step for `bash` and `tcl`. It assumes
Word wrap.

## Not available in

`lolcode`, `intercal`, `befunge`, `qsharp` and `asp` — no split, and in three of them no
strings to split.

## Source

- [Coding Dojo: String Calculator](https://codingdojo.org/kata/StringCalculator/) — which
  carries the full escalation, including the multiplication variant at the end
- [Kata-Log: String Calculator](https://kata-log.rocks/string-calculator-kata) — tagged
  Starter
