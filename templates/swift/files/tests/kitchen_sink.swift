import Foundation
import Testing

private func double(_ n: Int) -> Int {
  n * 2
}

private enum PercentageError: Error, Equatable {
  case notAPercentage(String)
}

private func parsePercentage(_ input: String) throws -> Int {
  guard let value = Int(input), (0...100).contains(value) else {
    throw PercentageError.notAPercentage(input)
  }

  return value
}

// collections

@Test("a list keeps what you put in it, in order")
func listKeepsOrder() {
  var items = ["a", "b"]

  items.append("c")

  #expect(items == ["a", "b", "c"])
  #expect(items.count == 3)
  #expect(Array(items[1...]) == ["b", "c"])
}

@Test("a lookup for a key that is not there comes back empty")
func lookupForMissingKeyComesBackEmpty() throws {
  let counts = ["a": 2, "b": 1]

  let value = try #require(counts["a"])

  #expect(value == 2)
  #expect(counts["z"] == nil)
  #expect((counts["z"] ?? 0) == 0)
}

@Test("a set discards duplicates")
func setDiscardsDuplicates() {
  let letters: Set = ["a", "b", "a"]

  #expect(letters.count == 2)
  #expect(letters.contains("a"))
  #expect(!letters.contains("z"))
}

// strings

@Test("a string splits into parts and joins back up")
func stringSplitsAndJoinsBackUp() {
  let parts = "one two three".split(separator: " ")

  #expect(parts == ["one", "two", "three"])
  #expect(parts.joined(separator: "-") == "one-two-three")
}

@Test("a slice of a string is taken from either end")
func stringSliceComesFromEitherEnd() {
  let text = "abcdef"

  #expect(text.prefix(3) == "abc")
  #expect(text.suffix(2) == "ef")
  #expect(text.dropFirst(4) == "ef")
}

@Test("text can be built up by interpolation")
func textIsBuiltByInterpolation() {
  let name = "world"
  let count = 2

  #expect("\(name) x\(count)" == "world x2")
  #expect(String(repeating: "ab", count: 3) == "ababab")
  #expect("  padded  ".trimmingCharacters(in: .whitespaces) == "padded")
}

// types and branching

@Test("assigning a struct copies it")
func assigningAStructCopiesIt() {
  struct Point {
    var x: Int
    var y: Int
  }
  let point = Point(x: 1, y: 2)

  var moved = point
  moved.x = 5

  #expect(moved.x == 5)
  #expect(point.x == 1)
}

@Test("a switch over an enum has to cover every case")
func switchOverAnEnumCoversEveryCase() {
  enum State {
    case locked, open
  }
  // Leave one case out and this stops compiling. That check is the reason to
  // reach for an enum over a pair of strings.
  func next(after state: State) -> State {
    switch state {
    case .locked: .open
    case .open: .locked
    }
  }

  #expect(next(after: .locked) == .open)
  #expect(next(after: .open) == .locked)
}

@Test("a branch produces a value instead of setting one")
func branchProducesAValue() {
  let values = [-1, 0, 1]

  let labels = values.map { n in
    if n < 0 {
      "negative"
    } else if n == 0 {
      "zero"
    } else {
      "positive"
    }
  }

  #expect(labels == ["negative", "zero", "positive"])
}

// iteration

@Test("a loop can read both the position and the item")
func loopReadsPositionAndItem() {
  var seen: [String] = []

  for (index, item) in ["a", "b"].enumerated() {
    seen.append("\(index):\(item)")
  }

  #expect(seen == ["0:a", "1:b"])
}

@Test("a sequence can be walked two items at a time")
func sequenceIsWalkedTwoItemsAtATime() {
  let values = [1, 2, 3, 4]

  let sums = zip(values, values.dropFirst()).map(+)

  #expect(sums == [3, 5, 7])
}

// functions

@Test("a function can be handed to another function")
func functionIsHandedToAnotherFunction() {
  let doubled = [1, 2, 3].map(double)
  let big = [1, 2, 3].filter { $0 > 1 }

  #expect(doubled == [2, 4, 6])
  #expect(big == [2, 3])
}

@Test("a list can be folded down to a single value")
func listIsFoldedToASingleValue() {
  let values = [1, 2, 3, 4]

  let total = values.reduce(0, +)

  #expect(total == 10)
}

// errors

@Test("an invalid input is refused rather than guessed at")
func invalidInputIsRefused() throws {
  #expect(try parsePercentage("40") == 40)

  #expect(throws: PercentageError.notAPercentage("half")) {
    try parsePercentage("half")
  }

  let held = Result { try parsePercentage("140") }

  #expect(throws: PercentageError.self) {
    try held.get()
  }
}

// gotchas

@Test("two strings spelled differently are still equal")
func stringsSpelledDifferentlyAreEqual() {
  let composed = "caf\u{e9}"
  let decomposed = "cafe\u{301}"

  #expect(composed == decomposed)
  #expect(decomposed.count == 4)
  #expect(decomposed.unicodeScalars.count == 5)
}
