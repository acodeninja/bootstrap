# Eight queens

Place eight queens on a chessboard so that none of them can take another: no two share a
row, a column or a diagonal. Find one arrangement, then find all of them.

In an imperative language this is a search you have to write — pick a square, recurse,
undo. In a logic language you write down what a legal board is and the solver finds the
boards, which is the entire argument for having a logic language in the first place and
the reason this kata sits where it does.

## What it teaches

Constraints as a description rather than a procedure, and backtracking where the language
makes you do it yourself. The first kata in the catalogue whose answer is a set of
solutions rather than a value.

## Where it sits

The last step on the Declarative track — `prolog`, `mercury`, `asp`. It assumes Turnstile,
which is the same shift in miniature: state and transitions written as facts and rules.

## Not available in

It is assigned only where it belongs. Nothing stops an imperative row from doing it, and
the catalogue note in the index says so, but no course outside the declarative three
reaches for it.

## Source

- [Coding Dojo: Eight Queens](https://codingdojo.org/kata/eight-queens/) — which also
  lists the routes beyond brute force, including the bitwise one
