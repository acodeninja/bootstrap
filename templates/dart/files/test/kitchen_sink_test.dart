import 'package:test/test.dart';

void main() {
  // collections

  test('a list keeps what you put in it, in order', () {
    final items = ['a', 'b'];

    items.add('c');

    expect(items, equals(['a', 'b', 'c']));
    expect(items.length, equals(3));
    expect(items.sublist(1, 3), equals(['b', 'c']));
  });

  test('a lookup for a key that is not there comes back empty', () {
    final counts = {'a': 2, 'b': 1};

    expect(counts['a'], equals(2));
    expect(counts['z'], isNull);
    expect(counts['z'] ?? 0, equals(0));
  });

  test('a set discards duplicates', () {
    final input = ['a', 'b', 'a'];

    final letters = <String>{}..addAll(input);

    expect(letters.length, equals(2));
    expect(letters.contains('a'), isTrue);
    expect(letters, equals({'a', 'b'}));
  });

  // strings

  test('a string splits into parts and joins back up', () {
    final words = 'one two three'.split(' ');

    expect(words, equals(['one', 'two', 'three']));
    expect(words.join('-'), equals('one-two-three'));
  });

  test('a slice of a string counts from zero', () {
    const text = 'abcdef';

    expect(text[0], equals('a'));
    expect(text.substring(0, 3), equals('abc'));
    expect(text.substring(text.length - 2), equals('ef'));
  });

  test('text can be built up by interpolation', () {
    const name = 'world';
    const count = 2;

    expect('$name x$count', equals('world x2'));
    expect('ab' * 3, equals('ababab'));
    expect('  padded  '.trim(), equals('padded'));
  });

  // types and branching

  test('a record groups related fields under one name', () {
    const record = (x: 1, y: 2);

    final moved = (x: 5, y: record.y);

    expect(moved, equals((x: 5, y: 2)));
    expect(record, equals((x: 1, y: 2)));
  });

  test('a switch over an enum has to cover every case', () {
    // Leave one of the two cases out and this stops compiling, which is the
    // reason to reach for an enum over a pair of strings.
    const state = _DoorState.locked;

    final next = switch (state) {
      _DoorState.locked => _DoorState.open,
      _DoorState.open => _DoorState.locked,
    };

    expect(next, equals(_DoorState.open));
  });

  test('a branch can produce a value instead of setting one', () {
    String describe(int n) => switch (n) {
      < 0 => 'negative',
      0 => 'zero',
      _ => 'positive',
    };

    expect(describe(-1), equals('negative'));
    expect(describe(0), equals('zero'));
    expect(describe(1), equals('positive'));
  });

  // iteration

  test('a loop can read both the position and the item', () {
    final items = ['a', 'b'];
    final seen = <String>[];

    for (final (index, item) in items.indexed) {
      seen.add('$index:$item');
    }

    expect(seen, equals(['0:a', '1:b']));
  });

  test('a sequence can be walked two items at a time', () {
    final values = [1, 2, 3, 4];
    final pairs = <int>[];

    for (var i = 0; i < values.length - 1; i++) {
      pairs.add(values[i] + values[i + 1]);
    }

    expect(pairs, equals([3, 5, 7]));
  });

  // functions

  test('a function can be handed to another function', () {
    int double(int n) => n * 2;

    final doubled = [1, 2, 3].map(double).toList();
    final big = [1, 2, 3].where((n) => n > 1).toList();

    expect(doubled, equals([2, 4, 6]));
    expect(big, equals([2, 3]));
  });

  test('a list can be folded down to a single value', () {
    final values = [1, 2, 3, 4];

    final total = values.fold(0, (sum, n) => sum + n);

    expect(total, equals(10));
  });

  // errors

  test('an invalid input is refused rather than guessed at', () {
    expect(_parsePercentage('40'), equals(40));
    expect(() => _parsePercentage('half'), throwsA(isA<_NotAPercentage>()));
    expect(() => _parsePercentage('140'), throwsA(isA<_NotAPercentage>()));
  });

  // gotchas

  test('two records with the same fields are equal, two objects are not', () {
    final a = _Point(1, 2);
    final b = _Point(1, 2);

    expect(a == b, isFalse);
    expect((x: 1, y: 2) == (x: 1, y: 2), isTrue);
  });
}

enum _DoorState { locked, open }

class _NotAPercentage implements Exception {
  _NotAPercentage(this.input);
  final String input;

  @override
  String toString() => 'not a percentage: "$input"';
}

int _parsePercentage(String input) {
  final value = int.tryParse(input);

  if (value == null || value < 0 || value > 100) {
    throw _NotAPercentage(input);
  }

  return value;
}

class _Point {
  _Point(this.x, this.y);
  final int x;
  final int y;
}
