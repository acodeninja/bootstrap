import utest.Assert;

class GreetingTest implements utest.ITest {
	public function new() {}

	public function testAGreetingAddressesTheNameItIsGiven() {
		Assert.equals("Hello, world!", {{PROJECT_SNAKE}}.Greeting.greet("world"));
	}
}
