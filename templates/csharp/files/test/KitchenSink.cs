namespace KitchenSink;

using System;
using System.Collections.Generic;
using System.Linq;
using Xunit;

public class KitchenSinkTests
{
    // collections

    [Fact]
    public void AppendingToAListChangesItInPlace()
    {
        var items = new List<string> { "a", "b" };

        items.Add("c");

        Assert.Equal(new[] { "a", "b", "c" }, items);
        Assert.Equal(3, items.Count);
    }

    [Fact]
    public void ADictionaryReportsAMissingKeyThroughABoolInsteadOfThrowing()
    {
        var counts = new Dictionary<string, int> { ["a"] = 2, ["b"] = 1 };

        Assert.True(counts.TryGetValue("a", out var a));
        Assert.Equal(2, a);
        Assert.False(counts.TryGetValue("z", out var z));
        Assert.Equal(0, z);
    }

    [Fact]
    public void ASetDiscardsDuplicates()
    {
        var letters = new HashSet<string> { "a", "b", "a" };

        Assert.Equal(2, letters.Count);
        Assert.Contains("a", letters);
        Assert.DoesNotContain("z", letters);
    }

    // strings

    [Fact]
    public void AStringSplitsIntoPartsAndJoinsBackUp()
    {
        var words = "one two three".Split(' ');

        Assert.Equal(new[] { "one", "two", "three" }, words);
        Assert.Equal("one-two-three", string.Join("-", words));
    }

    [Fact]
    public void ARangeSlicesAStringCountingFromEitherEnd()
    {
        var text = "abcdef";

        Assert.Equal('a', text[0]);
        Assert.Equal("abc", text[0..3]);
        Assert.Equal("ef", text[^2..]);
    }

    [Fact]
    public void TextCanBeBuiltUpByInterpolationAndRepetition()
    {
        var name = "world";
        var count = 2;

        Assert.Equal("world x2", $"{name} x{count}");
        Assert.Equal("ababab", string.Concat(Enumerable.Repeat("ab", 3)));
        Assert.Equal("padded", "  padded  ".Trim());
    }

    // types and branching

    public record Point(int X, int Y);

    [Fact]
    public void ARecordCopiesItselfWithOneFieldChanged()
    {
        var record = new Point(1, 2);

        var moved = record with { X = 5 };

        Assert.Equal(new Point(5, 2), moved);
        Assert.Equal(new Point(1, 2), record);
    }

    public enum State
    {
        Locked,
        Open,
    }

    // A switch expression over an enum warns, but does not fail to build, if
    // a case is left out -- there is no compiler error to depend on.
    [Fact]
    public void ASwitchExpressionTurnsEveryEnumCaseIntoAValue()
    {
        static State Next(State state) => state switch
        {
            State.Locked => State.Open,
            State.Open => State.Locked,
        };

        Assert.Equal(State.Open, Next(State.Locked));
        Assert.Equal(State.Locked, Next(State.Open));
    }

    [Fact]
    public void ABranchProducesAValueInsteadOfSettingOne()
    {
        static string Label(int n) => n switch
        {
            < 0 => "negative",
            0 => "zero",
            > 0 => "positive",
        };

        Assert.Equal("negative", Label(-1));
        Assert.Equal("zero", Label(0));
        Assert.Equal("positive", Label(1));
    }

    // iteration

    [Fact]
    public void ALoopCanReadBothThePositionAndTheItem()
    {
        var items = new[] { "a", "b" };
        var seen = new List<string>();

        for (var index = 0; index < items.Length; index++)
        {
            seen.Add($"{index}:{items[index]}");
        }

        Assert.Equal(new[] { "0:a", "1:b" }, seen);
    }

    [Fact]
    public void ASequenceCanBeWalkedTwoItemsAtATime()
    {
        var values = new[] { 1, 2, 3, 4 };

        var sums = values.Zip(values.Skip(1), (left, right) => left + right).ToList();

        Assert.Equal(new[] { 3, 5, 7 }, sums);
    }

    // functions

    [Fact]
    public void AFunctionCanBeHandedToAnotherFunction()
    {
        static int Double(int n) => n * 2;

        var doubled = new[] { 1, 2, 3 }.Select(Double).ToList();
        var big = new[] { 1, 2, 3 }.Where(n => n > 1).ToList();

        Assert.Equal(new[] { 2, 4, 6 }, doubled);
        Assert.Equal(new[] { 2, 3 }, big);
    }

    [Fact]
    public void AListCanBeFoldedDownToASingleValue()
    {
        var values = new[] { 1, 2, 3, 4 };

        var total = values.Aggregate(0, (sum, n) => sum + n);

        Assert.Equal(10, total);
    }

    // errors

    [Fact]
    public void AnInvalidInputIsRefusedRatherThanGuessedAt()
    {
        static int ParsePercentage(string input)
        {
            if (!int.TryParse(input, out var value) || value < 0 || value > 100)
            {
                throw new ArgumentException($"not a percentage: \"{input}\"");
            }

            return value;
        }

        Assert.Equal(40, ParsePercentage("40"));
        Assert.Throws<ArgumentException>(() => ParsePercentage("half"));
        Assert.Throws<ArgumentException>(() => ParsePercentage("140"));
    }

    // gotchas

    public struct Cell
    {
        public int Value;
    }

    [Fact]
    public void AssigningAStructCopiesItsFieldsInsteadOfSharingThem()
    {
        var original = new Cell { Value = 1 };

        var copy = original;
        copy.Value = 99;

        Assert.Equal(1, original.Value);
        Assert.Equal(99, copy.Value);
    }
}
