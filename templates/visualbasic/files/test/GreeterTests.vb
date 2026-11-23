Imports Xunit

Namespace GreeterTests

    Public Class GreeterTests

        <Fact>
        Public Sub AGreetingAddressesTheNameItIsGiven()
            Dim name = "world"

            Dim result = Greeting.Greeter.Greet(name)

            Assert.Equal("Hello, world!", result)
        End Sub

    End Class

End Namespace
