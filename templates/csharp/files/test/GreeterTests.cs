namespace GreeterTests;

using Xunit;

public class GreeterTests
{
    [Fact]
    public void AGreetingAddressesTheNameItIsGiven()
    {
        var name = "world";

        var greeting = Greeting.Greeter.Greet(name);

        Assert.Equal("Hello, world!", greeting);
    }
}
