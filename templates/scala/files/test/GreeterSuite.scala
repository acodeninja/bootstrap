// No imports at all, and that is not an omission. munit is a dependency declared
// in project.scala, and it is reached below by its full path -- munit.FunSuite --
// rather than by importing it. Greeter needs no import either: both files are in
// the same default package, so the name is already in scope.
//
// Nothing names this file. scala-cli compiles everything under test/ and munit
// finds each class extending FunSuite, so a suite is found by existing and
// deleting one is safe. Run them with `make test`.
class GreeterSuite extends munit.FunSuite:
  // `test(...)` is a method call, not syntax: the name is its first argument and
  // the body is a block passed as its second. That is why a test name can be any
  // string -- it is a string, and nothing had to be done to the language to
  // allow it. It is what a failure prints, so write it to read on its own.
  test("a greeting addresses the name it is given") {
    // Arrange, act, assert, separated by blank lines. `val` is a binding that
    // cannot be reassigned; `var` can be, and is rare.
    val name = "world"

    val greeting = Greeter.greet(name)

    // Actual first, expected second -- munit's order, and the opposite of
    // xUnit's. Swapping them still passes and only makes the failure message
    // name the wrong side as the problem.
    assertEquals(greeting, "Hello, world!")
  }
