module kitchen_sink;

import std.algorithm : filter, fold, map;
import std.array : array, join, replicate, split;
import std.container : redBlackTree;
import std.exception : assertThrown, basicExceptionCtors, collectExceptionMsg;
import std.format : format;
import std.range : slide;
import std.string : strip;

// collections

@("a dynamic array keeps what you put in it in order")
unittest
{
    auto items = ["a", "b"];

    items ~= "c";

    assert(items == ["a", "b", "c"]);
    assert(items.length == 3);
    assert(items[1 .. $] == ["b", "c"]);
}

@("a lookup for a key that is not there comes back empty")
unittest
{
    int[string] counts = ["a": 2, "b": 1];

    assert(counts["a"] == 2);
    assert("z" !in counts);
    assert(counts.get("z", 0) == 0);
}

@("a set discards duplicates")
unittest
{
    auto letters = redBlackTree("a", "b");

    const added = letters.insert("a");

    assert(added == 0);
    assert(letters.length == 2);
    assert("z" !in letters);
}

// strings

@("a string splits into parts and joins back up")
unittest
{
    auto words = "one two three".split(' ');

    assert(words == ["one", "two", "three"]);
    assert(words.join("-") == "one-two-three");
}

@("a slice of a string counts from zero")
unittest
{
    const text = "abcdef";

    assert(text[0 .. 1] == "a");
    assert(text[0 .. 3] == "abc");
    assert(text[$ - 2 .. $] == "ef");
}

@("text can be built up by formatting")
unittest
{
    const name = "world";
    const count = 2;

    assert(format!"%s x%s"(name, count) == "world x2");
    assert("ab".replicate(3) == "ababab");
    assert("  padded  ".strip == "padded");
}

// types and branching

private struct Point
{
    int x;
    int y;
}

@("a struct groups related fields and is copied by value")
unittest
{
    const point = Point(1, 2);

    Point moved = point;
    moved.x = 5;

    assert(moved == Point(5, 2));
    assert(point == Point(1, 2));
}

private enum Lock
{
    locked,
    open
}

private Lock toggle(Lock state)
{
    final switch (state)
    {
    case Lock.locked:
        return Lock.open;
    case Lock.open:
        return Lock.locked;
    }
}

@("a fixed set of named states must be matched exhaustively")
unittest
{
    // Dropping a case from toggle's final switch stops the module compiling.
    // That check is the reason to reach for an enum over a pair of strings.
    assert(toggle(Lock.locked) == Lock.open);
    assert(toggle(Lock.open) == Lock.locked);
}

@("a branch can produce a value instead of setting one")
unittest
{
    string describe(int n)
    {
        return n < 0 ? "negative" : n == 0 ? "zero" : "positive";
    }

    assert(describe(-1) == "negative");
    assert(describe(0) == "zero");
    assert(describe(1) == "positive");
}

// iteration

@("a loop can read both the position and the item")
unittest
{
    string[] seen;

    foreach (index, item; ["a", "b"])
    {
        seen ~= format!"%s:%s"(index, item);
    }

    assert(seen == ["0:a", "1:b"]);
}

@("a sequence can be walked two items at a time")
unittest
{
    const values = [1, 2, 3, 4];

    const sums = values.slide(2).map!(pair => pair[0] + pair[1]).array;

    assert(sums == [3, 5, 7]);
}

// functions

private int twice(int n)
{
    return n * 2;
}

@("a function can be handed to another function")
unittest
{
    const values = [1, 2, 3];

    const doubled = values.map!twice.array;
    const big = values.filter!(n => n > 1).array;

    assert(doubled == [2, 4, 6]);
    assert(big == [2, 3]);
}

@("a list can be folded down to a single value")
unittest
{
    const values = [1, 2, 3, 4];

    const total = values.fold!((sum, n) => sum + n);

    assert(total == 10);
}

// errors

private class PercentageException : Exception
{
    mixin basicExceptionCtors;
}

private ubyte parsePercentage(string input)
{
    import std.conv : ConvException, to;

    int value;

    try
    {
        value = input.to!int;
    }
    catch (ConvException)
    {
        throw new PercentageException("not a percentage");
    }

    if (value < 0 || value > 100)
    {
        throw new PercentageException("not a percentage");
    }

    return cast(ubyte) value;
}

@("an invalid input is refused rather than guessed at")
unittest
{
    assert(parsePercentage("40") == 40);
    assertThrown!PercentageException(parsePercentage("140"));
    assert(collectExceptionMsg(parsePercentage("half")) == "not a percentage");
}

// gotchas

@("writing through a slice reaches the array it came from")
unittest
{
    auto values = [1, 2, 3];
    auto head = values[0 .. 2];
    auto copy = values.dup[0 .. 2];

    head[0] = 9;
    copy[1] = 9;

    assert(values == [9, 2, 3]);
}
