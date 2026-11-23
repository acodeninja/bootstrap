case class Record(first: Int, second: Int)

enum State:
  case Locked, Open

enum ParseError:
  case NotANumber(input: String)
  case OutOfRange(value: Int)

def parsePercentage(input: String): Either[ParseError, Int] =
  input.toIntOption match
    case None                                    => Left(ParseError.NotANumber(input))
    case Some(value) if value < 0 || value > 100 => Left(ParseError.OutOfRange(value))
    case Some(value)                             => Right(value)

def requirePercentage(input: String): Int =
  parsePercentage(input) match
    case Right(value) => value
    case Left(error)  => throw IllegalArgumentException(error.toString)

class KitchenSink extends munit.FunSuite:

  // collections

  test("a list keeps what you put in it, in order") {
    val items = List("b", "c")

    val extended = "a" :: items

    assertEquals(extended, List("a", "b", "c"))
    assertEquals(extended.length, 3)
    assertEquals(extended.slice(1, 3), List("b", "c"))
  }

  test("a lookup for a key that is not there comes back as none") {
    val counts = Map("a" -> 2, "b" -> 1)

    assertEquals(counts.get("a"), Some(2))
    assertEquals(counts.get("z"), None)
    assertEquals(counts.getOrElse("z", 0), 0)
  }

  test("a set keeps one copy of each member") {
    val members = Set("a", "b", "a")

    assertEquals(members.size, 2)
    assert(members.contains("a"))
    assert(!members.contains("z"))
  }

  // strings

  test("a string splits into parts and joins back up") {
    val words = "one two three".split(" ").toList

    assertEquals(words, List("one", "two", "three"))
    assertEquals(words.mkString("-"), "one-two-three")
  }

  test("a slice of a string counts from zero") {
    val text = "abcdef"

    assertEquals(text.substring(0, 3), "abc")
    assertEquals(text(0), 'a')
    assertEquals(text.length, 6)
  }

  test("an interpolated string takes any expression") {
    val count = 2

    val label = s"world x${count + 0}"

    assertEquals(label, "world x2")
    assertEquals("ab" * 3, "ababab")
    assertEquals("  padded  ".strip(), "padded")
  }

  // types and branching

  test("a copy of a case class leaves the original alone") {
    val record = Record(1, 2)

    val changed = record.copy(first = 5)

    assertEquals(changed, Record(5, 2))
    assertEquals(record.first, 1)
  }

  test("every variant of an enum has to be matched") {
    val advance = (state: State) =>
      state match
        case State.Locked => State.Open
        case State.Open   => State.Locked

    assertEquals(advance(State.Locked), State.Open)
    assertEquals(advance(State.Open), State.Locked)
  }

  test("a match produces a value instead of setting one") {
    val describe = (value: Int) =>
      value match
        case v if v < 0 => "negative"
        case 0          => "zero"
        case _          => "positive"

    assertEquals(describe(-1), "negative")
    assertEquals(describe(0), "zero")
    assertEquals(describe(1), "positive")
  }

  // iteration

  test("the position in a sequence comes from pairing it with its indices") {
    val items = List("a", "b", "c")

    val labelled = for (item, index) <- items.zipWithIndex yield s"$index:$item"

    assertEquals(labelled, List("0:a", "1:b", "2:c"))
  }

  test("a sliding window hands each element its successor") {
    val items = List("a", "b", "c")

    val pairs = items.sliding(2).map(window => (window(0), window(1))).toList

    assertEquals(pairs, List(("a", "b"), ("b", "c")))
  }

  // functions

  test("a function can be handed to another function") {
    val double = (value: Int) => value * 2

    assertEquals(List(1, 2, 3).map(double), List(2, 4, 6))
    assertEquals(List(1, 2, 3).filter(_ > 1), List(2, 3))
  }

  test("a list folds down to a single value") {
    val values = List(1, 2, 3, 4)

    val total = values.foldLeft(0)(_ + _)

    assertEquals(total, 10)
  }

  // errors

  test("an invalid input comes back as a left rather than a guess") {
    assertEquals(parsePercentage("40"), Right(40))
    assertEquals(parsePercentage("140"), Left(ParseError.OutOfRange(140)))
    assertEquals(parsePercentage("half"), Left(ParseError.NotANumber("half")))

    val raised = intercept[IllegalArgumentException](requirePercentage("half"))

    assertEquals(raised.getMessage, "NotANumber(half)")
  }

  // gotchas

  test("two arrays holding the same elements are not equal") {
    val left = Array(1, 2)
    val right = Array(1, 2)

    assert(left != right)
    assert(left.sameElements(right))
    assertEquals(left.toList, right.toList)
  }
