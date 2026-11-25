-- Here the export list is load-bearing rather than good manners. elm-test finds
-- tests by looking for exposed values of type Test, so a test that is not in
-- this list does not run -- and nothing warns you, because an unexposed value
-- is perfectly legal. Adding a test means adding it here too.


module GreeterTest exposing (aGreetingAddressesTheNameItIsGiven)

-- Three imports, and the two forms are worth telling apart. A bare `import
-- Expect` makes the module available under its own name, so its functions are
-- written Expect.equal. `exposing (Test, test)` additionally brings those two
-- names into scope unqualified, which is why `test` below needs no prefix.

import Expect
import Greeter
import Test exposing (Test, test)



-- The annotation says this is a Test, which is what elm-test looks for. It is
-- not documentation here: change the type and the test stops being discovered.


aGreetingAddressesTheNameItIsGiven : Test
aGreetingAddressesTheNameItIsGiven =
    -- `test` takes a name and a function. The name is a plain string and can be
    -- a real sentence -- which it should be, because it is what a failure
    -- prints. The identifier above has to be camel case and merely echoes it.
    test "a greeting addresses the name it is given" <|
        -- <| applies the function on its left to the expression on its right,
        -- which saves a closing bracket at the end of the block. |> is the same
        -- operator the other way round and is far more common in real code.
        --
        -- The backslash opens an anonymous function and the underscore is a
        -- parameter whose value is ignored. elm-test hands every test one, so
        -- that nothing is evaluated until the runner asks for it.
        \_ ->
            -- Expect.equal takes expected first and actual second, and returns
            -- an Expectation rather than raising anything -- Elm has no
            -- exceptions, so a failing test is a value describing the failure.
            Expect.equal "Hello, world!" (Greeter.greet "world")
