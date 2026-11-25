-- The module name must match the filename, and the Spec suffix is what
-- hspec-discover looks for: test/Spec.hs is one line that runs it, and it
-- generates a main importing every *Spec.hs under test/ and running its `spec`.
-- So a test file is found by being named ...Spec.hs and exporting `spec`, and
-- nothing lists this file anywhere. Run the suite with `make test`.
module GreeterSpec (spec) where

-- Both of these import names rather than files. Greeter is the module beside the
-- project's entry point in src/; the parentheses narrow the import to `greet`,
-- which is the habit worth keeping -- an unqualified `import Test.Hspec` brings
-- in everything it exports.
import Greeter (greet)
import Test.Hspec

-- The type signature again, and here it is load-bearing: hspec-discover expects
-- a value called `spec` of type Spec, so this line is part of the contract
-- rather than documentation.
spec :: Spec
spec =
  -- `it` is an ordinary function taking a String and an action, so the test name
  -- is a real sentence with no identifier rules to fight. It is what a failure
  -- prints, so write it to read on its own.
  it "a greeting addresses the name it is given" $ do
    -- The dollar above applies the function on its left to everything on its
    -- right, which is how Haskell avoids a closing bracket at the end of a
    -- block. Note that a comment may not *begin* with that character: ormolu
    -- reads it as the start of a Haddock named chunk and deletes it.
    --
    -- Arrange, act, assert, separated by blank lines. `let` inside a do block
    -- binds a pure value; there is no assignment anywhere in the language, so
    -- this names a thing once and for good.
    let name = "world"

    let greeting = greet name

    -- Backticks turn a two-argument function into an infix operator, so
    -- `shouldBe` reads as English while being an ordinary call. Actual on the
    -- left, expected on the right -- which is the order the sentence implies.
    greeting `shouldBe` "Hello, world!"
