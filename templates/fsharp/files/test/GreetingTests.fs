module GreetingTests

open Xunit

[<Fact>]
let ``a greeting addresses the name it is given`` () =
    let name = "world"

    let greeting = Greeting.greet name

    Assert.Equal("Hello, world!", greeting)
