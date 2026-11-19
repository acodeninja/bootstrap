<?php

declare(strict_types=1);

namespace Tests;

use InvalidArgumentException;
use PHPUnit\Framework\TestCase;

enum Signal
{
    case Red;
    case Green;
}

function nextSignal(Signal $signal): Signal
{
    return match ($signal) {
        Signal::Red => Signal::Green,
        Signal::Green => Signal::Red,
    };
}

function describeSign(int $value): string
{
    return match (true) {
        $value < 0 => 'negative',
        $value === 0 => 'zero',
        default => 'positive',
    };
}

final class Point
{
    public function __construct(
        public readonly int $x,
        public readonly int $y,
    ) {
    }

    public function withX(int $x): self
    {
        return new self($x, $this->y);
    }
}

/**
 * @return array<string, int>
 */
function counts(): array
{
    return ['a' => 2, 'b' => 1];
}

function parsePercentage(string $input): int
{
    $value = filter_var($input, FILTER_VALIDATE_INT);

    if ($value === false || $value < 0 || $value > 100) {
        throw new InvalidArgumentException("not a percentage: \"{$input}\"");
    }

    return $value;
}

final class KitchenSinkTest extends TestCase
{
    // collections

    public function testAListKeepsWhatYouPutInItInOrder(): void
    {
        $items = ['a', 'b'];

        $items[] = 'c';

        $this->assertSame(['a', 'b', 'c'], $items);
        $this->assertCount(3, $items);
        $this->assertSame(['b', 'c'], array_slice($items, 1, 2));
    }

    public function testALookupForAKeyThatIsNotThereComesBackEmpty(): void
    {
        $counts = counts();

        $this->assertSame(2, $counts['a']);
        $this->assertFalse(isset($counts['z']));
        $this->assertSame(0, $counts['z'] ?? 0);
    }

    public function testDuplicateValuesCollapseWhenAnArrayIsUsedAsASet(): void
    {
        $letters = array_unique(['a', 'b', 'a']);

        $this->assertCount(2, $letters);
        $this->assertContains('a', $letters);
        $this->assertContains('b', $letters);
    }

    // strings

    public function testAStringSplitsIntoPartsAndJoinsBackUp(): void
    {
        $words = explode(' ', 'one two three');

        $this->assertSame(['one', 'two', 'three'], $words);
        $this->assertSame('one-two-three', implode('-', $words));
    }

    public function testASliceOfAStringCountsFromZero(): void
    {
        $text = 'abcdef';

        $this->assertSame('a', $text[0]);
        $this->assertSame('abc', substr($text, 0, 3));
        $this->assertSame('ef', substr($text, -2));
    }

    public function testTextCanBeBuiltUpByInterpolation(): void
    {
        $name = 'world';
        $count = 2;

        $this->assertSame('world x2', "{$name} x{$count}");
        $this->assertSame('ababab', str_repeat('ab', 3));
        $this->assertSame('padded', trim('  padded  '));
    }

    // types and branching

    public function testARecordGroupsRelatedFieldsUnderOneName(): void
    {
        $point = new Point(1, 2);

        $moved = $point->withX(5);

        $this->assertSame(5, $moved->x);
        $this->assertSame(2, $moved->y);
        $this->assertSame(1, $point->x);
    }

    public function testAFixedSetOfNamedStatesCanBeMatchedOneByOne(): void
    {
        $red = Signal::Red;

        $green = nextSignal($red);

        $this->assertSame(Signal::Green, $green);
        $this->assertSame(Signal::Red, nextSignal($green));
    }

    public function testABranchCanProduceAValueInsteadOfSettingOne(): void
    {
        $this->assertSame('negative', describeSign(-1));
        $this->assertSame('zero', describeSign(0));
        $this->assertSame('positive', describeSign(1));
    }

    // iteration

    public function testALoopCanReadBothThePositionAndTheItem(): void
    {
        $seen = [];

        foreach (['a', 'b'] as $index => $item) {
            $seen[] = "{$index}:{$item}";
        }

        $this->assertSame(['0:a', '1:b'], $seen);
    }

    public function testASequenceCanBeWalkedTwoItemsAtATime(): void
    {
        $values = [1, 2, 3, 4];
        $pairs = [];

        for ($i = 0; $i < count($values) - 1; $i++) {
            $pairs[] = $values[$i] + $values[$i + 1];
        }

        $this->assertSame([3, 5, 7], $pairs);
    }

    // functions

    public function testAFunctionCanBeHandedToAnotherFunction(): void
    {
        $double = fn (int $n): int => $n * 2;

        $doubled = array_map($double, [1, 2, 3]);
        $big = array_values(array_filter([1, 2, 3], fn (int $n): bool => $n > 1));

        $this->assertSame([2, 4, 6], $doubled);
        $this->assertSame([2, 3], $big);
    }

    public function testAListCanBeFoldedDownToASingleValue(): void
    {
        $values = [1, 2, 3, 4];

        $total = array_reduce($values, fn (int $sum, int $n): int => $sum + $n, 0);

        $this->assertSame(10, $total);
    }

    // errors

    public function testAnInvalidInputIsRefusedRatherThanGuessedAt(): void
    {
        $valid = parsePercentage('40');

        $this->assertSame(40, $valid);

        $this->expectException(InvalidArgumentException::class);
        $this->expectExceptionMessageMatches('/not a percentage/');

        parsePercentage('140');
    }

    // gotchas

    public function testANumericStringKeyIsSilentlyStoredAsAnInteger(): void
    {
        $record = ['1' => 'a', '01' => 'b'];

        $keys = array_keys($record);

        $this->assertSame(1, $keys[0]);
        $this->assertSame('01', $keys[1]);
        $this->assertSame('a', $record[1]);
    }
}
