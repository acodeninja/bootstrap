-- A module declaration, and the name must match the filename: module Greeter
-- lives in Greeter.hs and nowhere else. That is why this file is not named after
-- the project the way most templates here are -- a lower-case snake_case name is
-- not a legal module name, so the project's name went on the executable's entry
-- point instead, in the file beside this one.
--
-- The list in parentheses is the export list, and it is the whole of visibility:
-- `greet` is reachable because it is named there. Leaving the list off exports
-- everything, which is the easy habit to avoid.
module Greeter (greet) where

-- The type signature, on its own line above the definition. GHC would infer it
-- and you write it anyway: it is the first thing a reader of a Haskell function
-- looks at, and inference without it can produce a type more general than you
-- meant. :: reads as "has type", and -> separates argument from result.
greet :: String -> String
-- The definition. There is no `return`, no braces and no parentheses around the
-- parameter -- application is juxtaposition, so `greet name` is the call and
-- `greet name` here is the pattern it is defined by.
--
-- ++ concatenates two lists, and String *is* a list of Char, which is why the
-- same operator joins text. There is no interpolation in the language; printf
-- from Text.Printf is the nearest thing and is rarely what you want.
greet name = "Hello, " ++ name ++ "!"
