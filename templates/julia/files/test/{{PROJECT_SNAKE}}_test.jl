using Test
using {{PROJECT_SNAKE}}

@testset "a greeting addresses the name it is given" begin
    name = "world"

    greeting = greet(name)

    @test greeting == "Hello, world!"
end
