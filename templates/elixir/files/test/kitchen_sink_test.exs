defmodule KitchenSinkTest do
  use ExUnit.Case

  # collections

  test "a list keeps what you put in it, in order" do
    items = ["a", "b"]

    items = items ++ ["c"]

    assert items == ["a", "b", "c"]
    assert length(items) == 3
    assert Enum.slice(items, 1, 2) == ["b", "c"]
  end

  test "a map lookup for a key that is not there comes back nil" do
    counts = %{"a" => 2, "b" => 1}

    assert counts["a"] == 2
    assert counts["z"] == nil
    assert Map.get(counts, "z", 0) == 0
  end

  test "a set discards duplicates" do
    letters = Enum.reduce(["a", "b", "a"], MapSet.new(), &MapSet.put(&2, &1))

    assert MapSet.size(letters) == 2
    assert MapSet.member?(letters, "a")
    assert Enum.sort(MapSet.to_list(letters)) == ["a", "b"]
  end

  # strings

  test "a string splits into parts and joins back up" do
    words = String.split("one two three")

    assert words == ["one", "two", "three"]
    assert Enum.join(words, "-") == "one-two-three"
  end

  test "a slice of a string counts from zero" do
    text = "abcdef"

    assert String.at(text, 0) == "a"
    assert String.slice(text, 0, 3) == "abc"
    assert String.slice(text, -2, 2) == "ef"
  end

  test "text can be built up by interpolation" do
    name = "world"
    count = 2

    assert "#{name} x#{count}" == "world x2"
    assert String.duplicate("ab", 3) == "ababab"
    assert String.trim("  padded  ") == "padded"
  end

  # types and branching

  defmodule Point do
    defstruct [:x, :y]
  end

  test "a struct groups related fields under one name" do
    point = %Point{x: 1, y: 2}

    moved = %{point | x: 5}

    assert moved == %Point{x: 5, y: 2}
    assert point == %Point{x: 1, y: 2}
  end

  test "matching a value against an unlisted state raises" do
    next_state = fn state ->
      case state do
        :locked -> :open
        :open -> :locked
      end
    end

    unknown = List.first([:broken])

    assert next_state.(:locked) == :open
    assert next_state.(:open) == :locked
    assert_raise CaseClauseError, fn -> next_state.(unknown) end
  end

  test "a branch can produce a value instead of setting one" do
    describe = fn n ->
      cond do
        n < 0 -> "negative"
        n == 0 -> "zero"
        true -> "positive"
      end
    end

    assert describe.(-1) == "negative"
    assert describe.(0) == "zero"
    assert describe.(1) == "positive"
  end

  # iteration

  test "a loop can read both the position and the item" do
    seen = for {item, index} <- Enum.with_index(["a", "b"]), do: "#{index}:#{item}"

    assert seen == ["0:a", "1:b"]
  end

  test "a sequence can be walked two items at a time" do
    values = [1, 2, 3, 4]

    pairs = values |> Enum.chunk_every(2, 1, :discard) |> Enum.map(fn [a, b] -> a + b end)

    assert pairs == [3, 5, 7]
  end

  # functions

  test "a function can be handed to another function" do
    double = fn n -> n * 2 end

    doubled = Enum.map([1, 2, 3], double)
    big = Enum.filter([1, 2, 3], fn n -> n > 1 end)

    assert doubled == [2, 4, 6]
    assert big == [2, 3]
  end

  test "a list can be folded down to a single value" do
    values = [1, 2, 3, 4]

    total = Enum.reduce(values, 0, fn n, sum -> sum + n end)

    assert total == 10
  end

  # errors

  defp parse_percentage(input) do
    case Integer.parse(input) do
      {value, ""} when value in 0..100 -> {:ok, value}
      _ -> {:error, "not a percentage: #{input}"}
    end
  end

  defp parse_percentage!(input) do
    case parse_percentage(input) do
      {:ok, value} -> value
      {:error, reason} -> raise ArgumentError, reason
    end
  end

  test "an invalid input is refused rather than guessed at" do
    assert parse_percentage("40") == {:ok, 40}
    assert parse_percentage("140") == {:error, "not a percentage: 140"}
    assert_raise ArgumentError, "not a percentage: half", fn -> parse_percentage!("half") end
  end

  # gotchas

  test "an integer and a float can be == without being ===" do
    [count, total] = [1, 1.0]

    assert count == total
    refute count === total
  end
end
