// kotlin.test is the standard library's own facade: it delegates to whatever
// runner the build is configured for -- JUnit 5 here -- so the test reads the
// same whichever that is. Both of these are imports of names, not of files, and
// nothing in this file names the greeter's path.
import kotlin.test.Test
import kotlin.test.assertEquals

// Nothing names this file. Gradle compiles everything under test/ and the
// runner scans the result for @Test, so a test is found by existing and deleting
// one is safe. Run the suite with `make test`.
class GreeterTest {
    // @Test is the whole registration. The function is public by default, which
    // the runner needs, and returns Unit because it has no `=` body.
    //
    // The backtick-quoted name is the thing worth taking away: an identifier in
    // backticks may contain spaces, so a test name can be a real sentence
    // rather than camel case. It is what a failure prints, so write it to read
    // on its own.
    @Test
    fun `a greeting addresses the name it is given`() {
        // Arrange, act, assert, separated by blank lines. `val` is a read-only
        // binding and `var` is reassignable -- reach for `val` by default, and
        // note that neither says anything about the value being immutable.
        val name = "world"

        val greeting = Greeter.greet(name)

        // Expected first, actual second. Swapping them still passes and only
        // makes the failure message name the wrong side as the problem.
        assertEquals("Hello, world!", greeting)
    }
}
