// utest is a dependency rather than part of the standard library, installed by
// the image and named in build.hxml.
import utest.Assert;

// `implements utest.ITest` is the registration: utest takes any class declaring
// that interface and runs every method on it whose name begins with `test`. The
// runner is generated into the build directory, so nothing in the project names
// this file -- a test is found by implementing the interface, and deleting one
// is safe. Run the suite with `make test`.
class GreetingTest implements utest.ITest {
	// The empty constructor is required. utest instantiates the class to run
	// it, and a class with no constructor at all cannot be instantiated.
	public function new() {}

	// The `test` prefix is what makes this a test. Haxe identifiers cannot
	// contain spaces and utest has no annotation to carry a sentence, so the
	// name is camel case and reads as closely to one as it can.
	public function testAGreetingAddressesTheNameItIsGiven() {
		// Expected first, actual second. Note the fully qualified path to the
		// greeter: this file is in no package, so the class is not in scope
		// without naming its package.
		Assert.equals("Hello, world!", {{PROJECT_SNAKE}}.Greeting.greet("world"));
	}
}
