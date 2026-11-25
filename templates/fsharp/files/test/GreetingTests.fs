module GreetingTests

// `open` imports a namespace, not a file. xUnit is a NuGet package declared in
// the project file, and nothing here names the greeter's path -- the .fsproj
// compiled it earlier, which is what makes Greeting available below.
open Xunit

// Nothing names this test. xUnit scans the compiled assembly for [<Fact>], so a
// test is found by existing and deleting one is safe. Run them with `make test`.
//
// An attribute goes in [< >] brackets, which is F# rather than .NET: the same
// attribute is [Fact] in C# and <Fact> in Visual Basic.
//
// The double-backtick name is the thing worth taking away. An identifier wrapped
// in `` `` `` may contain spaces, so a test name can be a real sentence instead
// of camel case -- and it is what a failure prints, so write it to read on its
// own. `()` is the unit parameter: a function of no arguments still needs one.
[<Fact>]
let ``a greeting addresses the name it is given`` () =
    // Arrange, act, assert, separated by blank lines. `let` inside a function
    // is a local binding and is immutable; rebinding the same name shadows it
    // rather than assigning to it.
    let name = "world"

    // Application is juxtaposition: `greet name`, with no parentheses and no
    // comma. Parentheses here would pass a tuple, which is sometimes a
    // different thing entirely.
    let greeting = Greeting.greet name

    // Expected first, actual second -- xUnit's order, not F#'s. Swapping them
    // still passes and only makes the failure message name the wrong side.
    Assert.Equal("Hello, world!", greeting)
