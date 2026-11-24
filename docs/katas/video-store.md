# Video store

Print a rental statement. A customer rents films, each film is a regular release, a new
release or a children's film, and each kind charges differently — a flat rate for the
first few days and a daily rate after. The statement totals the charge and the loyalty
points.

You do not start from nothing. The kata is a working implementation with the pricing
buried in a chain of conditionals, and the exercise is to get it under test and then pull
the conditional apart into the three kinds of film. It is the oldest refactoring exercise
in the business: chapter 1 of Fowler's *Refactoring* is this program.

## What it teaches

Replacing a conditional with polymorphism, and the discipline that makes it safe — tests
that pin the current output before you touch anything, because the statement is the only
specification you have.

## Where it sits

The last step of the `smalltalk` and `objc` courses — a Message passing track ends on the
kata about dispatch. It assumes Tennis, and it assumes you can already write a test
without being told to.

## Not available in

The rows with no polymorphism to refactor towards: `sql`, `asp`, `bqn`, `befunge`,
`intercal`, `lolcode`, `basic`, `forth`, `arm32`, and `qsharp`, which has no sum type
either (`templates/qsharp/files/tests/kitchen_sink.qs:58`). The extract-a-function half
still works everywhere; the lesson the kata was written for does not.

Starting code is linked, never copied into this repo.

## Source

- [Made Tech: Video Store](https://learn.madetech.com/technology/katas/video-store/)
- [Clean Coders](https://cleancoders.com) — cited by that page
- [Coding Dojo: Movie Rental](https://codingdojo.org/kata/movie-rental/) — the same
  problem
- [Emily Bache: Theatrical-Players-Refactoring-Kata](https://github.com/emilybache/Theatrical-Players-Refactoring-Kata)
  — Fowler's chapter 1 with tests, in many languages
