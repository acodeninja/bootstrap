# Number to LCD

Render a number as seven-segment digits, three lines high, built from underscores and
pipes. Any number of digits, laid out left to right.

The output is two-dimensional, which is new: every line of the answer needs a piece of
every digit, so you cannot finish one digit before starting the next. That constraint is
the kata.

## What it teaches

A table mapping each digit to its three rows, then repeat, chunk and join to assemble
them. The first kata where the result is built across several accumulators at once.

## Where it sits

Step 4 on the Systems and Text processing tracks. It assumes Roman numerals or Word wrap,
for the string building.

## Not available in

The rows with no string indexing or no string at all: `lolcode`, `intercal`, `befunge`,
`qsharp`, `asp`.

## Source

- [Made Tech: Number to LCD](https://learn.madetech.com/technology/katas/number-to-lcd/),
  which has a
  [part 2](https://learn.madetech.com/technology/katas/number-to-lcd/part2.html) — the
  page asks you not to read it first, because adapting to it is the exercise
- [Coding Dojo: Number to LCD](https://codingdojo.org/kata/NumberToLCD/)
- The inverse problem is [Bank OCR](https://codingdojo.org/kata/BankOCR/): read the
  digits back out of the display
