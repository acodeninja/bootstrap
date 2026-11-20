module GreeterTest exposing (aGreetingAddressesTheNameItIsGiven)

import Expect
import Greeter
import Test exposing (Test, test)


aGreetingAddressesTheNameItIsGiven : Test
aGreetingAddressesTheNameItIsGiven =
    test "a greeting addresses the name it is given" <|
        \_ ->
            Expect.equal "Hello, world!" (Greeter.greet "world")
