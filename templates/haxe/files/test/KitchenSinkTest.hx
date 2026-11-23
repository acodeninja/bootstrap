/* Fifteen passing assertions: the toolbox for solving a kata in Haxe. */

import utest.Assert;

class KitchenSinkTest implements utest.ITest {
	public function new() {}

	// collections

	public function testAnArrayKeepsWhatYouPutInItInOrder() {
		var items = ["a", "b"];

		items.push("c");

		Assert.same(["a", "b", "c"], items);
		Assert.equals(3, items.length);
		Assert.same(["b", "c"], items.slice(1));
	}

	// A map's values are Null<Int> rather than Int, which is the type system
	// admitting out loud that a lookup can miss.
	public function testALookupForAKeyThatIsNotThereComesBackNull() {
		var counts = ["a" => 2, "b" => 1];

		Assert.equals(2, counts["a"]);
		Assert.isNull(counts["z"]);
		Assert.equals(0, counts.exists("z") ? counts["z"] : 0);
	}

	// There is no set in the standard library. A map to a value nobody reads is
	// the idiom, and its keys are the set.
	public function testAMapStandsInForTheSetHaxeDoesNotHave() {
		var letters = new Map<String, Bool>();

		for (letter in ["a", "b", "a"]) {
			letters[letter] = true;
		}

		Assert.equals(2, [for (key in letters.keys()) key].length);
		Assert.isTrue(letters.exists("a"));
		Assert.isFalse(letters.exists("c"));
	}

	// strings

	public function testAStringSplitsIntoPartsAndJoinsBackUp() {
		var words = "one two three".split(" ");

		Assert.same(["one", "two", "three"], words);
		Assert.equals("one-two-three", words.join("-"));
	}

	public function testASliceOfAStringCountsFromZero() {
		var text = "abcdef";

		Assert.equals("a", text.charAt(0));
		Assert.equals("abc", text.substring(0, 3));
		Assert.equals("ef", text.substr(-2));
	}

	// Interpolation belongs to the quote rather than to the string: only single
	// quotes expand $name and ${expression}.
	public function testOnlySingleQuotedTextInterpolates() {
		var name = "world";

		Assert.equals("world x2", '$name x${1 + 1}');
		Assert.equals("$name x2", "$name x2");
		Assert.equals("padded", StringTools.trim("  padded  "));
	}

	// types and branching

	public function testAStructureTypeNeedsNoDeclaration() {
		var record:Point = {x: 1, y: 2};

		var moved = {x: 5, y: record.y};

		Assert.equals(5, moved.x);
		Assert.equals(2, moved.y);
		Assert.equals(1, record.x);
	}

	// Drop a case and the switch stops compiling, which is the reason to reach
	// for an enum over a pair of strings. A constructor's argument arrives from
	// the pattern already typed.
	public function testASwitchOverAnEnumHasToCoverEveryCase() {
		var moves = [Stay, Step(2)];

		var distances = moves.map(move -> switch move {
			case Stay: 0;
			case Step(count): count;
		});

		Assert.same([0, 2], distances);
	}

	// An abstract is its own type to the compiler and its underlying Int to the
	// runtime, so the safety costs nothing and there is no wrapper to unwrap.
	public function testAnAbstractGivesAnIntItsOwnTypeForFree() {
		var filled = new Percentage(40);

		Assert.equals(40, filled.toInt());
		Assert.equals("40%", filled.label());
	}

	// iteration

	public function testALoopCanReadBothThePositionAndTheItem() {
		var items = ["a", "b"];
		var seen = [];

		for (index => item in items) {
			seen.push('$index:$item');
		}

		Assert.same(["0:a", "1:b"], seen);
	}

	public function testASequenceCanBeWalkedTwoItemsAtATime() {
		var values = [1, 2, 3, 4];

		var pairs = [for (at in 0...values.length - 1) values[at] + values[at + 1]];

		Assert.same([3, 5, 7], pairs);
	}

	// functions

	public function testAFunctionCanBeHandedToAnotherFunction() {
		var double = (n:Int) -> n * 2;

		Assert.same([2, 4, 6], [1, 2, 3].map(double));
		Assert.same([2, 3], [1, 2, 3].filter(n -> n > 1));
	}

	public function testAnArrayIsFoldedDownToASingleValue() {
		var values = [1, 2, 3, 4];

		var total = Lambda.fold(values, (value, carried) -> carried + value, 0);

		Assert.equals(10, total);
	}

	// errors
	//
	// Failure is a thrown value, and since 4.1 the class to extend is
	// haxe.Exception. catch dispatches on the type, so a caller can refuse one
	// kind of failure and let the rest past.
	public function testAnInvalidInputIsRefusedByThrowing() {
		Assert.equals(40, parsePercentage("40"));
		Assert.raises(() -> parsePercentage("half"), NotAPercentage);
		Assert.raises(() -> parsePercentage("140"), NotAPercentage);
	}

	// gotchas
	//
	// The hour this saves: == is reference equality for anything with fields,
	// so two structures that read as identical are not equal. Two enum values
	// carrying arguments will not compile as == at all, and the compiler's own
	// advice is Type.enumEq.
	public function testTwoStructuresWithTheSameFieldsAreNotEqual() {
		var left = {x: 1, y: 2};
		var right = {x: 1, y: 2};

		Assert.isFalse(left == right);
		Assert.isTrue(left.x == right.x && left.y == right.y);
		Assert.isTrue(Type.enumEq(Step(2), Step(2)));
	}

	static function parsePercentage(input:String):Int {
		var value = Std.parseInt(input);

		if (value == null || value < 0 || value > 100) {
			throw new NotAPercentage(input);
		}

		return value;
	}
}

typedef Point = {x:Int, y:Int};

enum Move {
	Stay;
	Step(count:Int);
}

abstract Percentage(Int) {
	public inline function new(value:Int) {
		this = value;
	}

	public inline function toInt():Int {
		return this;
	}

	public inline function label():String {
		return '${this}%';
	}
}

class NotAPercentage extends haxe.Exception {
	public function new(input:String) {
		super('not a percentage: "$input"');
	}
}
