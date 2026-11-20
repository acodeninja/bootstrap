module Main (main) where

import Greeter (greet)

main :: IO ()
main = putStrLn (greet "world")
