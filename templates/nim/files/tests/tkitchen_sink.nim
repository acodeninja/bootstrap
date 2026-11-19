## Fifteen passing assertions: the toolbox for solving a kata in Nim.

import std/[unittest, strutils, sequtils, tables, sets]

# collections

test "a sequence keeps what you put in it, in order":
  var items = @["a", "b"]

  items.add("c")

  check items == @["a", "b", "c"]
  check items.len == 3
  check items[1 .. 2] == @["b", "c"]

test "a lookup for a key that is not there comes back empty":
  let counts = {"a": 2, "b": 1}.toTable

  check counts["a"] == 2
  check not counts.hasKey("z")
  check counts.getOrDefault("z", 0) == 0

test "a set discards duplicates":
  let letters = ["a", "b", "a"].toHashSet

  check letters.len == 2
  check "a" in letters
  check "z" notin letters

# strings

test "a string splits into parts and joins back up":
  let words = "one two three".split(" ")

  check words == @["one", "two", "three"]
  check words.join("-") == "one-two-three"

test "a slice of a string counts from zero":
  let text = "abcdef"

  check text[0] == 'a'
  check text[0 .. 2] == "abc"
  check text[^2 .. ^1] == "ef"

test "text can be built up by interpolation":
  let name = "world"
  let count = 2

  check "$1 x$2" % [name, $count] == "world x2"
  check "ab".repeat(3) == "ababab"
  check "  padded  ".strip() == "padded"

# types and branching

type Point = object
  x, y: int

test "assigning an object copies its value":
  let point = Point(x: 1, y: 2)

  var moved = point
  moved.x = 5

  check moved.x == 5
  check point.x == 1

type State = enum
  locked, open

test "a case statement over an enum has to cover every value":
  # Leave one of the two branches out and this stops compiling. That check is
  # the reason to reach for an enum over a pair of strings.
  let state = locked

  let next = case state
    of locked: open
    of open: locked

  check next == open

test "a case expression produces a value instead of setting one":
  let cases = [(-1, "negative"), (0, "zero"), (1, "positive")]

  for (n, label) in cases:
    let described =
      if n < 0: "negative"
      elif n == 0: "zero"
      else: "positive"

    check described == label

# iteration

test "a loop can read both the position and the item":
  let items = @["a", "b", "c"]
  var found = -1

  for index, item in items:
    if item == "b":
      found = index

  check found == 1

test "a sequence can be walked two items at a time":
  let values = @[1, 2, 3, 4]
  var sums: seq[int] = @[]

  for i in 0 ..< values.len - 1:
    sums.add(values[i] + values[i + 1])

  check sums == @[3, 5, 7]

# functions

proc double(n: int): int = n * 2

test "a function can be handed to another function":
  let values = @[1, 2, 3]

  let doubled = values.map(double)

  check doubled == @[2, 4, 6]

test "a list is folded down to a single value":
  let values = @[1, 2, 3, 4]

  let total = values.foldl(a + b)

  check total == 10

# errors

proc parsePercentage(input: string): int =
  let value = parseInt(input)
  if value < 0 or value > 100:
    raise newException(ValueError, "not a percentage: " & input)
  value

test "an invalid input is refused rather than guessed at":
  check parsePercentage("40") == 40
  expect ValueError:
    discard parsePercentage("140")

# gotchas

proc describe(n: int): string =
  # `result` starts at the type's default and is returned however the proc
  # falls out, so a branch that never sets it hands back "" rather than
  # failing in any visible way.
  if n > 0:
    result = "positive"

test "a proc's implicit result stays empty when no branch sets it":
  check describe(5) == "positive"
  check describe(-5) == ""
