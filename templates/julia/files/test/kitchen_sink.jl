using Test

# collections

@testset "a vector keeps what you push into it in order" begin
    items = ["a", "b"]

    push!(items, "c")

    @test items == ["a", "b", "c"]
    @test length(items) == 3
    @test items[2:3] == ["b", "c"]
end

@testset "a dictionary lookup for a key that is not there needs a fallback" begin
    counts = Dict("a" => 2, "b" => 1)

    @test counts["a"] == 2
    @test get(counts, "z", 0) == 0
    @test !haskey(counts, "z")
end

@testset "a set discards duplicates" begin
    letters = Set(["a", "b", "a"])

    @test length(letters) == 2
    @test "a" in letters
    @test !("z" in letters)
end

# strings

@testset "a string splits into parts and joins back up" begin
    text = "one two three"

    words = split(text)

    @test words == ["one", "two", "three"]
    @test join(words, "-") == "one-two-three"
end

@testset "indexing a string gives back a character rather than a string" begin
    text = "abcdef"

    @test text[1] == 'a'
    @test text[1:3] == "abc"
    @test last(text, 2) == "ef"
end

@testset "text is built up by interpolation" begin
    name = "world"
    count = 2

    @test "$name x$count" == "world x2"
    @test "ab"^3 == "ababab"
    @test strip("  padded  ") == "padded"
end

# types and branching

struct Point
    x::Int
    y::Int
end

@testset "a struct groups related fields and cannot be changed in place" begin
    point = Point(1, 2)

    moved = Point(5, point.y)

    @test moved == Point(5, 2)
    @test point.x == 1
    @test_throws ErrorException (point.x = 9)
end

@enum Latch LOCKED OPEN

# Nothing checks that every state has a branch: add a Latch member and toggle
# answers LOCKED for it rather than failing.
toggle(latch::Latch) = latch == LOCKED ? OPEN : LOCKED

@testset "a fixed set of named states is matched one branch at a time" begin
    @test toggle(LOCKED) == OPEN
    @test toggle(OPEN) == LOCKED
    @test instances(Latch) == (LOCKED, OPEN)
end

describe(n) = n < 0 ? "negative" : n == 0 ? "zero" : "positive"

@testset "a branch produces a value instead of setting one" begin
    @test describe(-1) == "negative"
    @test describe(0) == "zero"
    @test describe(1) == "positive"
end

# iteration

@testset "a loop can read both the position and the item" begin
    items = ["a", "b"]
    seen = String[]

    for (index, item) in enumerate(items)
        push!(seen, "$index:$item")
    end

    @test seen == ["1:a", "2:b"]
end

@testset "a sequence is walked two at a time by zipping it with its own tail" begin
    values = [1, 2, 3, 4]

    sums = [left + right for (left, right) in zip(values, values[2:end])]

    @test sums == [3, 5, 7]
end

# functions

@testset "a function can be handed to another function" begin
    double(n) = n * 2

    values = [1, 2, 3]

    @test map(double, values) == [2, 4, 6]
    @test filter(n -> n > 1, values) == [2, 3]
end

@testset "a list is folded down to a single value" begin
    values = [1, 2, 3, 4]

    @test foldl(+, values; init = 0) == 10
    @test reduce(*, values) == 24
end

# errors

struct NotAPercentage <: Exception
    input::String
end

function parse_percentage(input)
    value = tryparse(Int, input)

    if value === nothing || !(0 <= value <= 100)
        throw(NotAPercentage(input))
    end

    value
end

@testset "an invalid input is refused rather than guessed at" begin
    @test parse_percentage("40") == 40
    @test_throws NotAPercentage parse_percentage("half")
    @test_throws NotAPercentage parse_percentage("140")
end

# gotchas

@testset "assigning an array to a second name does not copy it" begin
    items = ["a", "b"]
    alias = items
    copied = copy(items)

    push!(alias, "c")

    @test items == ["a", "b", "c"]
    @test alias === items
    @test copied == ["a", "b"]
end
