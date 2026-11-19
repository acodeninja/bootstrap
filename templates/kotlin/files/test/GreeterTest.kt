import kotlin.test.Test
import kotlin.test.assertEquals

class GreeterTest {
    @Test
    fun `a greeting addresses the name it is given`() {
        val name = "world"

        val greeting = Greeter.greet(name)

        assertEquals("Hello, world!", greeting)
    }
}
