import Std.Data.HashMap
import Std.Data.HashSet
import test

-- collections

#eval do
  let items := ["b", "c"]

  let extended := "a" :: items

  check "a list grows at the front and keeps its order" <|
    extended == ["a", "b", "c"] && extended.length == 3 && extended.take 2 == ["a", "b"]

#eval do
  let counts := Std.HashMap.ofList [("a", 2), ("b", 1)]

  check "a key that is not in a map reads as none rather than failing" <|
    counts["a"]? == some 2 && counts["z"]? == none && counts.getD "z" 0 == 0

#eval do
  let members := Std.HashSet.ofList ["a", "b", "a"]

  check "a set keeps one copy of each member" <|
    members.size == 2 && members.contains "a" && !members.contains "z"

-- strings

#eval do
  let words := "one two three".splitOn " "

  check "a string splits into parts and joins back up" <|
    words == ["one", "two", "three"] && String.intercalate "-" words == "one-two-three"

#eval do
  let word := "kata"

  check "interpolation splices a value, slices included, into a literal" <|
    s!"{word.take 2}-{word.drop 2}" == "ka-ta"

#eval do
  let padded := "  kata  "

  let trimmed := padded.trimAscii.toString

  check "trimming hands back a slice, and toString makes it a String again" <|
    trimmed == "kata" && trimmed.toList[0]? == some 'k'

-- types and branching

structure Record where
  label : String
  count : Nat

inductive Gate where
  | locked
  | unlocked
  deriving BEq

def toggle : Gate → Gate
  | .locked => .unlocked
  | .unlocked => .locked

#eval do
  let record := ({ label := "a", count := 1 } : Record)

  let bumped := { record with count := 2 }

  check "updating a structure copies the fields you do not name" <|
    bumped.count == 2 && bumped.label == "a" && record.count == 1

#eval do
  check "a match over a type's constructors has to cover all of them" <|
    toggle Gate.locked == Gate.unlocked && toggle Gate.unlocked == Gate.locked

#eval do
  let count := 3

  let parity := if count % 2 == 0 then "even" else "odd"

  check "if is an expression, so a branch yields a value" <| parity == "odd"

-- iteration

#eval do
  let weights := [10, 20, 30]

  let total := Id.run do
    let mut sum := 0
    for (weight, index) in weights.zipIdx do
      sum := sum + weight * index
    return sum

  check "a loop reaches the index by pairing each element with it" <| total == 80

#eval do
  let frames := [1, 2, 4]

  check "zipping a list with its own tail puts each element beside the next" <|
    frames.zip frames.tail == [(1, 2), (2, 4)]

-- functions

def twice (step : Nat → Nat) (start : Nat) : Nat := step (step start)

#eval do
  check "a function passed as an argument is applied like any other" <|
    twice (· + 3) 1 == 7

#eval do
  check "folding threads an accumulator through the list from the left" <|
    [1, 2, 3].foldl (fun carried digit => carried * 10 + digit) 0 == 123

-- errors

def parseCount (text : String) : Except String Nat :=
  match text.toNat? with
  | some count => .ok count
  | none => .error s!"not a count: {text}"

#eval do
  let refused := parseCount "x"

  check "a refusal comes back as an Except whose error branch carries the reason" <|
    (parseCount "12").toOption == some 12
      && (match refused with
          | .ok _ => false
          | .error reason => reason == "not a count: x")

-- gotchas

#eval do
  check "subtracting past zero on Nat gives zero rather than a negative" <|
    2 - 3 == 0 && (2 : Int) - 3 == -1
