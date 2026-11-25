# Parse a time

Parse a time of day — `9am`, `14:30`, `quarter past six` — into hours and minutes. Write it
as a grammar: named rules, alternatives, and an action class that builds the result as the
parse succeeds.

Then feed it something that is not a time, and report where it stopped.

## What it teaches

That a parser is a first-class thing with its own declaration form. A grammar is a class
whose methods are rules, the rules are regexes that can call each other, and the whole
thing is debuggable and testable rule by rule — which is the difference between this and
the single enormous regular expression most languages would reach for.

The action class is the half worth the evening. Keeping *what the text is* separate from
*what to build from it* is the design lesson, and Raku is the only row here that hands you
the separation for free.

## Where it sits

Step 3 on `raku`. It assumes FizzBuzz, and leads to
[string calculator](string-calculator.md), which is this with requirements arriving.

## Not available in

Nothing else here has grammars in the language. `perl` and `python` build the same thing
out of regular expressions and a hand-written recursive descent;
`prolog` has DCGs, which are the nearest relative and are not wired into this template.

## Source

Written for this repo. The template's kitchen sink does not mention grammars, so this is
new ground. Documented at
[Raku: Grammars](https://docs.raku.org/language/grammars).
