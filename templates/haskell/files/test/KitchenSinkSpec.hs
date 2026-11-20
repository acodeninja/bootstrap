-- | Fifteen passing tests: the toolbox for solving a kata in Haskell.
module KitchenSinkSpec (spec) where

import Control.Exception (ArithException (DivideByZero), evaluate)
import Data.List (intercalate)
import qualified Data.Map.Strict as Map
import qualified Data.Set as Set
import Test.Hspec

data Point = Point {x :: Int, y :: Int}
  deriving (Eq, Show)

data State = Locked | Open
  deriving (Eq, Show)

data ParseError
  = NotANumber String
  | OutOfRange Int
  deriving (Eq, Show)

unlock :: State -> State
unlock Locked = Open
unlock Open = Locked

classify :: Int -> String
classify n
  | n < 0 = "negative"
  | n == 0 = "zero"
  | otherwise = "positive"

lookahead :: [Int] -> [Int]
lookahead (first : second : rest) = first + second : lookahead (second : rest)
lookahead _ = []

parsePercentage :: String -> Either ParseError Int
parsePercentage input = case reads input of
  [(value, "")]
    | value >= 0, value <= 100 -> Right value
    | otherwise -> Left (OutOfRange value)
  _ -> Left (NotANumber input)

spec :: Spec
spec = do
  -- collections

  it "a list keeps what you put in it, in order" $ do
    let items = ["a", "b"]

    let appended = items ++ ["c"]

    appended `shouldBe` ["a", "b", "c"]
    length appended `shouldBe` 3
    take 2 (drop 1 appended) `shouldBe` ["b", "c"]

  it "a lookup for a key that is not there comes back as Nothing" $ do
    let counts = Map.fromList [("a", 2 :: Int), ("b", 1)]

    Map.lookup "a" counts `shouldBe` Just 2
    Map.lookup "z" counts `shouldBe` Nothing
    Map.findWithDefault 0 "z" counts `shouldBe` 0

  it "a set discards duplicates and holds its members in order" $ do
    let letters = Set.fromList "bab"

    Set.size letters `shouldBe` 2
    Set.member 'a' letters `shouldBe` True
    Set.toList letters `shouldBe` "ab"

  -- strings

  it "a string splits into parts and joins back up" $ do
    let parts = words "one two three"

    parts `shouldBe` ["one", "two", "three"]
    unwords parts `shouldBe` "one two three"
    intercalate "-" parts `shouldBe` "one-two-three"

  it "a slice of a string counts from zero" $ do
    let text = "abcdef"

    take 1 text `shouldBe` "a"
    take 3 text `shouldBe` "abc"
    drop 4 text `shouldBe` "ef"

  it "text is built up by joining pieces rather than interpolating them" $ do
    let count = 2 :: Int

    ("world x" ++ show count) `shouldBe` "world x2"
    concat (replicate 3 "ab") `shouldBe` "ababab"
    unwords (words "  padded  ") `shouldBe` "padded"

  -- types and branching

  it "updating a record returns a new one and leaves the original alone" $ do
    let point = Point {x = 1, y = 2}

    let moved = point {x = 5}

    moved `shouldBe` Point {x = 5, y = 2}
    y moved `shouldBe` 2
    point `shouldBe` Point {x = 1, y = 2}

  it "a function over a sum type has to cover every constructor" $ do
    -- Drop the Open equation and -Wall reports the gap. That check is the
    -- reason to reach for a sum type over a pair of strings.
    unlock Locked `shouldBe` Open
    unlock Open `shouldBe` Locked

  it "a branch produces a value instead of setting one" $ do
    classify (-1) `shouldBe` "negative"
    classify 0 `shouldBe` "zero"
    classify 1 `shouldBe` "positive"

  -- iteration

  it "a loop with the index is a list zipped with its own positions" $ do
    let items = ["a", "b", "c"]

    let numbered = zip [0 :: Int ..] items

    numbered `shouldBe` [(0, "a"), (1, "b"), (2, "c")]
    lookup 1 numbered `shouldBe` Just "b"

  it "a sequence is walked with lookahead by a function that calls itself" $ do
    -- Haskell has no while and no until. A loop that has to stop early, or
    -- carry state, is spelled as recursion with a base case.
    let values = [1, 2, 3, 4] :: [Int]

    lookahead values `shouldBe` [3, 5, 7]
    lookahead [1] `shouldBe` []

  -- functions

  it "a function can be handed to another function" $ do
    let double n = n * 2 :: Int

    map double [1, 2, 3] `shouldBe` [2, 4, 6]
    filter (> 1) [1, 2, 3 :: Int] `shouldBe` [2, 3]

  it "a list is folded to one value, because there is no loop to write" $ do
    let values = [1, 2, 3, 4] :: [Int]

    let combined = foldl' (\acc value -> acc * 10 + value) 0 values

    combined `shouldBe` 1234
    sum values `shouldBe` 10

  -- errors

  it "an invalid input is refused rather than guessed at" $ do
    parsePercentage "40" `shouldBe` Right 40
    parsePercentage "half" `shouldBe` Left (NotANumber "half")
    parsePercentage "140" `shouldBe` Left (OutOfRange 140)

  -- gotchas

  it "the length of a list is known without looking at the items in it" $ do
    let values = map (div 10) [2, 1, 0] :: [Int]

    length values `shouldBe` 3
    take 2 values `shouldBe` [5, 10]
    evaluate (sum values) `shouldThrow` (== DivideByZero)
