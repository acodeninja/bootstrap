class GreeterSuite extends munit.FunSuite:
  test("a greeting addresses the name it is given") {
    val name = "world"

    val greeting = Greeter.greet(name)

    assertEquals(greeting, "Hello, world!")
  }
