' Imports brings in a namespace rather than a file. xUnit is a NuGet package
' declared in the project file, and nothing here names the greeter's path.
Imports Xunit

Namespace GreeterTests

    ' Nothing names this file. The SDK compiles every .vb it finds and xUnit
    ' scans the assembly for <Fact>, so a test is found by existing and deleting
    ' one is safe. Run the suite with `make test`.
    Public Class GreeterTests

        ' An attribute goes in angle brackets here, where C# uses square ones
        ' and F# uses [< >]. <Fact> is the whole registration.
        '
        ' The test is a Sub because it returns nothing. A Visual Basic
        ' identifier cannot contain spaces and xUnit has no attribute to carry a
        ' sentence, so the name is Pascal case and reads as close to one as it
        ' can -- it is what a failure prints.
        <Fact>
        Public Sub AGreetingAddressesTheNameItIsGiven()
            ' Arrange, act, assert, separated by blank lines. `Dim` declares a
            ' local; with no `As` clause the type is inferred from the value,
            ' and it is still statically typed.
            Dim name = "world"

            ' Fully qualified, because this namespace imported Xunit and nothing
            ' else.
            Dim result = Greeting.Greeter.Greet(name)

            ' Expected first, actual second. Swapping them still passes and only
            ' makes the failure message name the wrong side as the problem.
            Assert.Equal("Hello, world!", result)
        End Sub

    End Class

End Namespace
