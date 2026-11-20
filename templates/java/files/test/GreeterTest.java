import static org.junit.jupiter.api.Assertions.assertEquals;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;

class GreeterTest {
  @Test
  @DisplayName("a greeting addresses the name it is given")
  void greetsByName() {
    String name = "world";

    String greeting = Greeter.greet(name);

    assertEquals("Hello, world!", greeting);
  }
}
