# `using` imports and brings exported names into scope unqualified, which is why
# `greet` below needs no prefix. Test is the standard library's own framework --
# there is nothing to install and nothing in Project.toml for it.
using Test
using {{PROJECT_SNAKE}}

# Nothing names this file. Pkg.test runs test/runtests.jl and nothing else, and
# that file globs this directory rather than listing it -- deliberately, because
# a list would break the moment a file was deleted. So a test file is found by
# existing. Run the suite with `make test`.
#
# @testset is a macro, so the name is an ordinary string and can be a real
# sentence. It also catches failures inside it and carries on, printing a summary
# at the end -- without a testset, the first failure stops the run.
@testset "a greeting addresses the name it is given" begin
    # Arrange, act, assert, separated by blank lines.
    name = "world"

    greeting = greet(name)

    # @test is a macro over an ordinary expression, so a failure prints the
    # expression and both values -- which is why there is no assert_equal here
    # and no expected-first order to remember.
    @test greeting == "Hello, world!"
end
