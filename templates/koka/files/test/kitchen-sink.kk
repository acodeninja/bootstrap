// Fifteen passing assertions: the toolbox for solving a kata in Koka.

module kitchen-sink

import lib/tap

struct entry
  label : string
  count : int

type state
  Open
  Closed
  Locked

fun describe( s : state ) : string
  match s
    Open   -> "open"
    Closed -> "closed"
    Locked -> "locked"

fun doubled( n : int ) : int
  n * 2

// `apply` is already in std/core, and a clash is an error rather than a
// shadow: Koka resolves overloads by type and reports the ambiguity.
fun apply-to( f : int -> int, n : int ) : int
  f(n)

// `exn` is an effect like any other, so the signature is the declaration that
// this can fail. A caller that does not handle it carries `exn` in turn.
fun digit-of( c : char ) : exn int
  if c >= '0' && c <= '9' then (c - '0').int
  else throw("not a digit: " ++ c.string)

fun countdown( n : int ) : div int
  if n <= 0 then 0 else countdown(n - 1)

pub fun main() : <console,div,exn> ()
  with suite(15)

  // collections

  val items = [1, 2, 4, 8]
  ok(items.length == 4 && items[2] == Just(4) && items[9] == Nothing,
    "indexing a list answers with a maybe, so a position past the end is Nothing")

  // Perceus frees a cell as soon as the last reference to it goes, so these
  // answer with fresh lists -- and where the input is not shared, the
  // compiler reuses its cells in place rather than allocating a copy.
  ok(items ++ [16] == [1, 2, 4, 8, 16] && items.take(2) == [1, 2],
    "appending and slicing answer with new lists, because a list is immutable")

  // std/data/map and std/data/set are declared and empty in 3.2.9, so a
  // keyed collection is a list of pairs and a lookup is a walk.
  val counts = [("a", 1), ("b", 2)]
  ok(counts.lookup(fn(k) k == "b") == Just(2) && counts.lookup(fn(k) k == "z") == Nothing,
    "a lookup walks a list of pairs, because the standard library ships no map")

  // strings

  ok("a,b,c".split(",").join("-") == "a-b-c",
    "splitting on one separator and joining with another rewrites a line")

  ok("abcdef".first(3).string == "abc" && "abcdef".head-char == Just('a'),
    "a string is cut by taking a slice of it, and its first character is a maybe")

  ok("ab".repeat(3) == "ababab" && "count: " ++ 3.show == "count: 3",
    "a number reaches a string through show, because ++ takes two strings")

  // types and branching

  val first = Entry("a", 1)
  ok(first.label == "a" && first(count = 2).count == 2,
    "a struct is copied by naming only the fields that change")

  // `match` is checked for exhaustiveness: dropping a branch is an error.
  ok(describe(Locked) == "locked",
    "matching every constructor of a type yields a value")

  val size = if items.length > 2 then "long" else "short"
  ok(size == "long",
    "if yields a value, because it is an expression rather than a statement")

  // iteration

  // `while` is an ordinary function taking two blocks, not syntax, and a
  // `var` is what makes the body's writes visible to the next round.
  var at := 0
  var weighted := 0
  while { at < 4 }
    weighted := weighted + (at + 1) * 2
    at := at + 1
  ok(weighted == 20,
    "a counting loop writes through a var, and while takes its condition in braces")

  val gaps = items.map-peek fn(value, rest)
    match rest
      Cons(next, _) -> next - value
      Nil -> 0
  ok(gaps == [1, 2, 4, 0],
    "map-peek hands each element the rest of the list, which is how you look ahead")

  // functions

  ok(apply-to(doubled, 21) == 42,
    "a function passed to another function carries its effect row in its type")

  ok(items.foldl(0, fn(acc, x) acc + x) == 15,
    "foldl collapses a list to one value, and takes the accumulator first")

  // errors

  val got = try { digit-of('7') }
  val refused = try { digit-of('x') }
  ok(got.default(-1) == 7 && refused.default(-1) == -1,
    "throw is an operation of the exn effect, and try hands back an Ok or an Error")

  // gotchas

  // The hour this saves: the row is part of the type, so a function whose
  // body gained an effect no longer matches the signature you wrote for it.
  // Here termination is not structural, Koka infers `div`, and `: int` alone
  // is a type error rather than a warning.
  ok(countdown(5) == 0,
    "a recursion Koka cannot see terminating is typed div, which the signature has to admit")
