# Wordle

Score a guess against a target word. A letter in the right place scores 2, a letter in
the word but the wrong place scores 1, and a letter that is not there scores 0.

The duplicate-letter rule is the kata. A letter that appears twice in the guess and once
in the target can only be credited once, so the answer depends on how many of each letter
remain unclaimed — and a suite that only tests words with distinct letters passes while
the code is wrong.

## What it teaches

A map from letter to count, a set for membership, and comparing two sequences position by
position. The first kata where the obvious implementation is wrong and the tests are what
tell you.

## Where it sits

No course uses it. It is the natural kata after Mars Rover for anyone who wants a second
one, and it needs a word list — which means file I/O, deliberately absent from every
template (`docs/kitchen-sink.md:93`). Embed a short list and it is a fine exercise.

## Not available in

The rows with no character access: `lolcode`, `intercal`, `befunge`, `qsharp`, `asp`.

## Source

- [Made Tech: Wordle](https://learn.madetech.com/technology/katas/wordle/)
