module KitchenSink

open System
open Xunit

// collections

[<Fact>]
let ``appending to a list gives back a new list`` () =
    let items = [ "a"; "b" ]

    let extended = items @ [ "c" ]

    Assert.Equal<string list>([ "a"; "b"; "c" ], extended)
    Assert.Equal(3, extended.Length)
    Assert.Equal<string list>([ "a"; "b" ], items)

[<Fact>]
let ``a lookup for a key that is not there comes back as None`` () =
    let counts = Map [ "a", 2; "b", 1 ]

    Assert.Equal(Some 2, counts.TryFind "a")
    Assert.Equal(None, counts.TryFind "z")
    Assert.Equal(0, counts.TryFind "z" |> Option.defaultValue 0)

[<Fact>]
let ``a set discards duplicates`` () =
    let letters = Set [ "a"; "b"; "a" ]

    Assert.Equal(2, letters.Count)
    Assert.True(letters.Contains "a")
    Assert.False(letters.Contains "z")

// strings

[<Fact>]
let ``a string splits into parts and joins back up`` () =
    let words = "one two three".Split(' ')

    Assert.Equal<string array>([| "one"; "two"; "three" |], words)
    Assert.Equal("one-two-three", String.Join("-", words))

[<Fact>]
let ``a slice of a string counts from zero and includes both ends`` () =
    let text = "abcdef"

    Assert.Equal('a', text[0])
    Assert.Equal("abc", text[0..2])
    Assert.Equal("ef", text[4..])

[<Fact>]
let ``text can be built up by interpolation`` () =
    let name = "world"
    let count = 2

    Assert.Equal("world x2", $"{name} x{count}")
    Assert.Equal("ababab", String.replicate 3 "ab")
    Assert.Equal("padded", "  padded  ".Trim())

// types and branching

type Point = { X: int; Y: int }

[<Fact>]
let ``a record copies itself with one field changed`` () =
    let record = { X = 1; Y = 2 }

    let moved = { record with X = 5 }

    Assert.Equal({ X = 5; Y = 2 }, moved)
    Assert.Equal({ X = 1; Y = 2 }, record)

type State =
    | Locked
    | Open

[<Fact>]
let ``a match over a union turns every case into a value`` () =
    // Leave a case out and the compiler says so (FS0025). A lookup table in a
    // language without unions gets no such warning.
    let next state =
        match state with
        | Locked -> Open
        | Open -> Locked

    Assert.Equal(Open, next Locked)
    Assert.Equal(Locked, next Open)

[<Fact>]
let ``a branch produces a value instead of setting one`` () =
    let label n =
        if n < 0 then "negative"
        elif n = 0 then "zero"
        else "positive"

    Assert.Equal("negative", label (-1))
    Assert.Equal("zero", label 0)
    Assert.Equal("positive", label 1)

// iteration

[<Fact>]
let ``a loop can read both the position and the item`` () =
    let seen = ResizeArray<string>()

    for index, item in List.indexed [ "a"; "b" ] do
        seen.Add $"{index}:{item}"

    Assert.Equal<string list>([ "0:a"; "1:b" ], List.ofSeq seen)

[<Fact>]
let ``a sequence can be walked two items at a time`` () =
    let values = [ 1; 2; 3; 4 ]

    let sums = values |> List.pairwise |> List.map (fun (left, right) -> left + right)

    Assert.Equal<int list>([ 3; 5; 7 ], sums)

// functions

[<Fact>]
let ``a function can be handed to another function`` () =
    let double n = n * 2

    let doubled = [ 1; 2; 3 ] |> List.map double
    let big = [ 1; 2; 3 ] |> List.filter (fun n -> n > 1)

    Assert.Equal<int list>([ 2; 4; 6 ], doubled)
    Assert.Equal<int list>([ 2; 3 ], big)

[<Fact>]
let ``a list can be folded down to a single value`` () =
    let values = [ 1; 2; 3; 4 ]

    let total = values |> List.fold (fun sum n -> sum + n) 0

    Assert.Equal(10, total)

// errors

type PercentageError =
    | NotANumber of string
    | OutOfRange of int

[<Fact>]
let ``an invalid input is refused rather than guessed at`` () =
    let parsePercentage (input: string) =
        match Int32.TryParse input with
        | false, _ -> Error(NotANumber input)
        | true, value when value < 0 || value > 100 -> Error(OutOfRange value)
        | true, value -> Ok value

    Assert.Equal(Ok 40, parsePercentage "40")
    Assert.Equal(Error(NotANumber "half"), parsePercentage "half")
    Assert.Equal(Error(OutOfRange 140), parsePercentage "140")

// gotchas

[<Fact>]
let ``a sequence runs again every time it is walked`` () =
    let calls = ref 0

    let values =
        [ 1; 2; 3 ]
        |> Seq.map (fun n ->
            calls.Value <- calls.Value + 1
            n * 2)

    Assert.Equal(0, calls.Value)
    Assert.Equal<int list>([ 2; 4; 6 ], List.ofSeq values)
    Assert.Equal<int list>([ 2; 4; 6 ], List.ofSeq values)
    Assert.Equal(6, calls.Value)
