namespace GreeterTests;

// xUnit is a NuGet package rather than part of the runtime, and the project file
// is where it is declared. `using` imports a namespace; it is not an import of a
// file, which is why nothing here names the greeter's path.
using Xunit;

// Nothing names this file either. The SDK compiles every .cs it finds and xUnit
// scans the assembly for [Fact], so a test is found by existing and deleting one
// is safe. Run the suite with `make test`.
public class GreeterTests
{
    // [Fact] is the whole registration: an attribute on a method, and it is now
    // a test. [Theory] is the other one, for a test taking arguments.
    //
    // A C# method name cannot contain spaces and xUnit has no attribute to carry
    // a sentence, so the name is Pascal case and reads as close to one as it
    // can. It is what a failure prints.
    [Fact]
    public void AGreetingAddressesTheNameItIsGiven()
    {
        // Arrange, act, assert, separated by blank lines. `var` infers the type
        // from the right-hand side -- the variable is still statically typed,
        // and still a string here.
        var name = "world";

        // Fully qualified, because the test is in its own namespace and nothing
        // above imported Greeting.
        var greeting = Greeting.Greeter.Greet(name);

        // Expected first, actual second. Swapping them still passes and only
        // makes the failure message name the wrong side as the problem.
        Assert.Equal("Hello, world!", greeting);
    }
}
