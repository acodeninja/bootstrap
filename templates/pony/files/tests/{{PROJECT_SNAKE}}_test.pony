use "pony_test"
use "src"

class iso TestGreeting is UnitTest
  fun name(): String => "a greeting names whoever it is given"

  fun apply(h: TestHelper) =>
    let greeting = Greeter.greet("world")

    h.assert_eq[String]("Hello, world!", greeting)
