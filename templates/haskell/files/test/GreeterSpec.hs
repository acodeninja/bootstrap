module GreeterSpec (spec) where

import Greeter (greet)
import Test.Hspec

spec :: Spec
spec =
  it "a greeting addresses the name it is given" $ do
    let name = "world"

    let greeting = greet name

    greeting `shouldBe` "Hello, world!"
