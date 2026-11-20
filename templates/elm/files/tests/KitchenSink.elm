module KitchenSink exposing (..)

import Dict
import Expect
import Set
import Test exposing (Test, test)



-- collections


aListKeepsWhatYouPutInItInOrder : Test
aListKeepsWhatYouPutInItInOrder =
    test "a list keeps what you put in it, in order" <|
        \_ ->
            let
                items =
                    [ "b", "c" ]
            in
            Expect.all
                [ \list -> Expect.equal [ "a", "b", "c" ] list
                , \list -> Expect.equal 3 (List.length list)
                , \list -> Expect.equal [ "b", "c" ] (List.drop 1 list)
                ]
                ("a" :: items)


aLookupForAKeyThatIsNotThereComesBackAsNothing : Test
aLookupForAKeyThatIsNotThereComesBackAsNothing =
    test "a lookup for a key that is not there comes back as Nothing" <|
        \_ ->
            let
                counts =
                    Dict.fromList [ ( "a", 2 ), ( "b", 1 ) ]
            in
            Expect.all
                [ \dict -> Expect.equal (Just 2) (Dict.get "a" dict)
                , \dict -> Expect.equal Nothing (Dict.get "z" dict)
                , \dict -> Expect.equal 0 (Maybe.withDefault 0 (Dict.get "z" dict))
                ]
                counts


aSetDiscardsDuplicatesAndSortsWhatIsLeft : Test
aSetDiscardsDuplicatesAndSortsWhatIsLeft =
    test "a set discards duplicates and sorts what is left" <|
        \_ ->
            let
                letters =
                    Set.fromList [ "c", "a", "c" ]
            in
            Expect.all
                [ \set -> Expect.equal 2 (Set.size set)
                , \set -> Expect.equal True (Set.member "a" set)
                , \set -> Expect.equal [ "a", "c" ] (Set.toList set)
                ]
                letters



-- strings


aStringSplitsIntoPartsAndJoinsBackUp : Test
aStringSplitsIntoPartsAndJoinsBackUp =
    test "a string splits into parts and joins back up" <|
        \_ ->
            let
                words =
                    String.split " " "one two three"
            in
            Expect.all
                [ \parts -> Expect.equal [ "one", "two", "three" ] parts
                , \parts -> Expect.equal "one-two-three" (String.join "-" parts)
                ]
                words


oneCharacterComesFromASliceOrAListRatherThanAnIndex : Test
oneCharacterComesFromASliceOrAListRatherThanAnIndex =
    test "one character comes from a slice or a list, rather than an index" <|
        \_ ->
            let
                text =
                    "abcdef"
            in
            Expect.all
                [ \value -> Expect.equal "abc" (String.slice 0 3 value)
                , \value -> Expect.equal "ef" (String.right 2 value)
                , \value -> Expect.equal (Just 'a') (List.head (String.toList value))
                ]
                text


textIsBuiltUpByConcatenationBecauseThereIsNoInterpolation : Test
textIsBuiltUpByConcatenationBecauseThereIsNoInterpolation =
    test "text is built up by concatenation, because there is no interpolation" <|
        \_ ->
            Expect.all
                [ \_ -> Expect.equal "world x2" ("world" ++ " x" ++ String.fromInt 2)
                , \_ -> Expect.equal "ababab" (String.repeat 3 "ab")
                , \_ -> Expect.equal "padded" (String.trim "  padded  ")
                ]
                ()



-- types and branching


updatingARecordYieldsANewOneAndLeavesTheOriginalAlone : Test
updatingARecordYieldsANewOneAndLeavesTheOriginalAlone =
    test "updating a record yields a new one and leaves the original alone" <|
        \_ ->
            let
                record =
                    { x = 1, y = 2 }
            in
            Expect.all
                [ \_ -> Expect.equal { x = 5, y = 2 } { record | x = 5 }
                , \_ -> Expect.equal { x = 1, y = 2 } record
                ]
                ()


type Gate
    = Locked
    | Open


nextState : Gate -> Gate
nextState gate =
    case gate of
        Locked ->
            Open

        Open ->
            Locked


aCaseOnACustomTypeMustListEveryStateToCompile : Test
aCaseOnACustomTypeMustListEveryStateToCompile =
    test "a case on a custom type must list every state to compile" <|
        \_ ->
            Expect.all
                [ \_ -> Expect.equal Open (nextState Locked)
                , \_ -> Expect.equal Locked (nextState Open)
                ]
                ()


sign : Int -> String
sign value =
    if value < 0 then
        "negative"

    else if value == 0 then
        "zero"

    else
        "positive"


aBranchProducesAValueRatherThanSettingOne : Test
aBranchProducesAValueRatherThanSettingOne =
    test "a branch produces a value rather than setting one" <|
        \_ ->
            Expect.all
                [ \_ -> Expect.equal "negative" (sign -1)
                , \_ -> Expect.equal "zero" (sign 0)
                , \_ -> Expect.equal "positive" (sign 1)
                ]
                ()



-- iteration


walkingAListWithItsPositionsIsIndexedMapBecauseThereIsNoLoop : Test
walkingAListWithItsPositionsIsIndexedMapBecauseThereIsNoLoop =
    test "walking a list with its positions is indexedMap, because there is no loop" <|
        \_ ->
            let
                label index item =
                    String.fromInt index ++ ":" ++ item
            in
            Expect.equal [ "0:a", "1:b" ] (List.indexedMap label [ "a", "b" ])


sumsOfNeighbours : List Int -> List Int
sumsOfNeighbours values =
    case values of
        first :: second :: rest ->
            (first + second) :: sumsOfNeighbours (second :: rest)

        _ ->
            []


aSequenceIsWalkedTwoItemsAtATimeByRecursion : Test
aSequenceIsWalkedTwoItemsAtATimeByRecursion =
    test "a sequence is walked two items at a time by recursion" <|
        \_ ->
            Expect.equal [ 3, 5, 7 ] (sumsOfNeighbours [ 1, 2, 3, 4 ])



-- functions


double : Int -> Int
double value =
    value * 2


aFunctionCanBeHandedToAnotherFunction : Test
aFunctionCanBeHandedToAnotherFunction =
    test "a function can be handed to another function" <|
        \_ ->
            Expect.all
                [ \_ -> Expect.equal [ 2, 4, 6 ] (List.map double [ 1, 2, 3 ])
                , \_ -> Expect.equal [ 2, 3 ] (List.filter (\value -> value > 1) [ 1, 2, 3 ])
                ]
                ()


aListIsFoldedDownToASingleValueFromEitherEnd : Test
aListIsFoldedDownToASingleValueFromEitherEnd =
    test "a list is folded down to a single value from either end" <|
        \_ ->
            Expect.all
                [ \_ -> Expect.equal 10 (List.foldl (+) 0 [ 1, 2, 3, 4 ])
                , \_ -> Expect.equal "cba" (List.foldl (++) "" [ "a", "b", "c" ])
                , \_ -> Expect.equal "abc" (List.foldr (++) "" [ "a", "b", "c" ])
                ]
                ()



-- errors


type Problem
    = NotANumber String
    | OutOfRange Int


percentage : String -> Result Problem Int
percentage input =
    case String.toInt input of
        Nothing ->
            Err (NotANumber input)

        Just value ->
            if value < 0 || value > 100 then
                Err (OutOfRange value)

            else
                Ok value


anInvalidInputComesBackAsAnErrBecauseNothingIsEverThrown : Test
anInvalidInputComesBackAsAnErrBecauseNothingIsEverThrown =
    test "an invalid input comes back as an Err, because nothing is ever thrown" <|
        \_ ->
            -- Elm has no exceptions and no try. A function that can fail says
            -- so in its type: Maybe for absence, Result for the reason.
            Expect.all
                [ \_ -> Expect.equal (Ok 40) (percentage "40")
                , \_ -> Expect.equal (Err (NotANumber "half")) (percentage "half")
                , \_ -> Expect.equal (Err (OutOfRange 140)) (percentage "140")
                , \_ -> Expect.equal Nothing (String.toInt "4.5")
                ]
                ()



-- gotchas


modByTakesTheDivisorFirstAndDisagreesWithRemainderByOnNegatives : Test
modByTakesTheDivisorFirstAndDisagreesWithRemainderByOnNegatives =
    test "modBy takes the divisor first and disagrees with remainderBy on negatives" <|
        \_ ->
            Expect.all
                [ \_ -> Expect.equal 1 (modBy 2 7)
                , \_ -> Expect.equal 11 (modBy 12 -1)
                , \_ -> Expect.equal -1 (remainderBy 12 -1)
                ]
                ()
