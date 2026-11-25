// A static import brings in the member itself rather than its class, which is what lets
// the assertion below read as a bare assertEquals(...) instead of
// Assertions.assertEquals(...). JUnit 5 is the org.junit.jupiter packages; org.junit
// without the jupiter is JUnit 4, and the two are different libraries.
import static org.junit.jupiter.api.Assertions.assertEquals;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;

// Nothing anywhere names this file. Gradle compiles every source file under test/ and
// JUnit scans the result for @Test, so a test is found by existing -- which is why
// `make test` runs a bare `gradle test` that names no file, and why deleting one is safe.
//
// Run the suite with `make test`. A single test is
// `make shell` then `gradle test --tests GreeterTest`.
class GreeterTest {
  // @Test is the whole registration: one annotation, and the method is now a test. It is
  // package-private and returns void by convention rather than by requirement.
  //
  // A Java method name cannot contain spaces, so the name a human reads goes in
  // @DisplayName -- that string is what the test report, the IDE and a CI failure show,
  // and greetsByName is only what the compiler needs. Write the sentence so it reads on
  // its own: a failure quotes it with nothing around it.
  @Test
  @DisplayName("a greeting addresses the name it is given")
  void greetsByName() {
    // Arrange, act, assert, separated by blank lines. Every test in this project has
    // these three parts in this order, and the blank lines are how you see them.
    String name = "world";

    String greeting = Greeter.greet(name);

    // Expected first, actual second. Swapping them still passes, so nothing catches it --
    // it only makes the failure message name the wrong side as the problem.
    assertEquals("Hello, world!", greeting);
  }
}
