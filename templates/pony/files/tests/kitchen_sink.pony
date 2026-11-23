use "collections"
use "itertools"
use "pony_test"

// collections

class iso TestArray is UnitTest
  fun name(): String => "an array grows at the end and is indexed from zero"

  fun apply(h: TestHelper) ? =>
    let items = Array[String]

    items.push("first")
    items.push("second")

    h.assert_eq[USize](2, items.size())
    h.assert_eq[String]("second", items(1)?)
    h.assert_true(items.contains("first"))

class iso TestMap is UnitTest
  fun name(): String => "a lookup for a key that is not there raises an error"

  fun apply(h: TestHelper) ? =>
    let counts = Map[String, USize]

    counts("a") = 2
    counts("b") = 1

    h.assert_eq[USize](2, counts("a")?)
    h.assert_eq[USize](0, counts.get_or_else("z", 0))
    h.assert_false(counts.contains("z"))

class iso TestSet is UnitTest
  fun name(): String => "a set keeps one copy of each member"

  fun apply(h: TestHelper) =>
    let members = Set[String]

    members.set("a")
    members.set("b")
    members.set("a")

    h.assert_eq[USize](2, members.size())
    h.assert_true(members.contains("a"))

// strings

class iso TestSplitAndJoin is UnitTest
  fun name(): String => "a string splits into parts and joins back up"

  fun apply(h: TestHelper) =>
    let words: Array[String] = "one two three".split(" ")

    h.assert_eq[USize](3, words.size())
    h.assert_eq[String]("one-two-three", "-".join(words.values()))

class iso TestSlice is UnitTest
  fun name(): String => "a string is sliced and indexed by byte, not by character"

  fun apply(h: TestHelper) ? =>
    let text = "abcdef"

    h.assert_eq[String]("abc", text.substring(0, 3))
    h.assert_eq[U8]('a', text(0)?)
    h.assert_eq[USize](6, text.size())

class iso TestConcatenation is UnitTest
  fun name(): String =>
    "a value joins a string by being added, as there is no interpolation"

  fun apply(h: TestHelper) =>
    let count: USize = 2

    h.assert_eq[String]("world x2", "world x" + count.string())
    h.assert_eq[String]("ababab", "ab".mul(3))

// types and branching

class iso TestRecord is UnitTest
  fun name(): String => "a class groups related fields under one name"

  fun apply(h: TestHelper) =>
    let record = _Record(1, "two")

    h.assert_eq[USize](1, record.first)
    h.assert_eq[String]("two", record.second)

class iso TestStates is UnitTest
  fun name(): String =>
    "a union of primitives is the fixed set of states a match must cover"

  fun apply(h: TestHelper) =>
    h.assert_is[_State](_Open, _Turnstile.advance(_Locked))
    h.assert_is[_State](_Locked, _Turnstile.advance(_Open))

class iso TestMatchYieldsAValue is UnitTest
  fun name(): String => "a match produces a value instead of setting one"

  fun apply(h: TestHelper) =>
    h.assert_eq[String]("negative", _Describe(-1))
    h.assert_eq[String]("zero", _Describe(0))
    h.assert_eq[String]("positive", _Describe(1))

// iteration

class iso TestIndexedLoop is UnitTest
  fun name(): String => "the position in a sequence comes from the call that walks it"

  fun apply(h: TestHelper) =>
    let items = ["a"; "b"; "c"]
    let labelled = Array[String]

    for (index, item) in items.pairs() do
      labelled.push(index.string() + ":" + item)
    end

    h.assert_eq[String]("0:a 1:b 2:c", " ".join(labelled.values()))

class iso TestLookahead is UnitTest
  fun name(): String => "a walk with lookahead stops one place short of the end"

  fun apply(h: TestHelper) ? =>
    let values = [as USize: 1; 2; 4; 7]
    let gaps = Array[USize]

    var index: USize = 0
    while index < (values.size() - 1) do
      gaps.push(values(index + 1)? - values(index)?)
      index = index + 1
    end

    h.assert_array_eq[USize]([as USize: 1; 2; 3], gaps)

// functions

class iso TestHigherOrder is UnitTest
  fun name(): String => "a function can be handed to another function"

  fun apply(h: TestHelper) =>
    let double = {(value: USize): USize => value * 2}

    h.assert_eq[USize](12, _Twice(3, double))

class iso TestFold is UnitTest
  fun name(): String => "a sequence folds down to a single value"

  fun apply(h: TestHelper) =>
    let values = [as USize: 1; 2; 3; 4]

    let total = Iter[USize](values.values())
      .fold[USize](0, {(sum: USize, value: USize): USize => sum + value})

    h.assert_eq[USize](10, total)

// errors

class iso TestError is UnitTest
  fun name(): String =>
    "a refused input raises an error, which carries no detail of its own"

  fun apply(h: TestHelper) ? =>
    h.assert_eq[USize](40, _Percentage("40")?)

    h.assert_error({()? =>
      _Percentage("140")?
      None
    })
    h.assert_error({()? =>
      _Percentage("half")?
      None
    })

// gotchas

class iso TestRecover is UnitTest
  fun name(): String =>
    "a mutable array turns immutable only by being built inside recover"

  fun apply(h: TestHelper) ? =>
    let frozen: Array[USize] val =
      recover val
        let building = Array[USize]
        building.push(1)
        building.push(2)
        building
      end

    h.assert_eq[USize](2, frozen.size())
    h.assert_eq[USize](1, frozen(0)?)

class val _Record
  let first: USize
  let second: String

  new val create(first': USize, second': String) =>
    first = first'
    second = second'

primitive _Locked
primitive _Open

type _State is (_Locked | _Open)

primitive _Turnstile
  fun advance(state: _State): _State =>
    match state
    | _Locked => _Open
    | _Open => _Locked
    end

primitive _Describe
  fun apply(value: I64): String =>
    match value
    | let negative: I64 if negative < 0 => "negative"
    | 0 => "zero"
    else
      "positive"
    end

primitive _Twice
  fun apply(value: USize, transform: {(USize): USize} val): USize =>
    transform(transform(value))

primitive _Percentage
  fun apply(input: String): USize ? =>
    let value = input.usize()?
    if value > 100 then error end
    value
