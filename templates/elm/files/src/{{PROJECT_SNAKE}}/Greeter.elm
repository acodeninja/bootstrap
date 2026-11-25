-- A module declaration, and the name must match the path below a source
-- directory *and* start with a capital. That rules out naming this file after
-- the project, because the token is lower case and no Elm module could live in
-- it -- so elm.json makes src/<project> a source directory and the module
-- inside it is a plain Greeter.
--
-- The list after `exposing` is the whole of visibility: a name not in it is
-- private to the module. `exposing (..)` exports everything and is the habit to
-- avoid.


module Greeter exposing (greet)

-- The type annotation, on its own line above the definition. The compiler would
-- infer it; you write it anyway, and in Elm more than anywhere else it is worth
-- it -- the compiler checks your annotation against the body, so the two
-- disagreeing is an error rather than a silent generalisation.
--
-- The arrow separates argument from result, and a function of two arguments is
-- written String -> String -> String: there is only ever one arrow shape,
-- because every function takes one argument and returns either a value or
-- another function.


greet : String -> String
greet name =
    -- ++ appends two strings, and it is the only way to build one: Elm has no
    -- interpolation. There is no `return` either, because a function body is an
    -- expression rather than a sequence of statements -- there is nothing to
    -- return *from*.
    "Hello, " ++ name ++ "!"
