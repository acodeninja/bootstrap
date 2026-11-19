import { test } from 'node:test';
import assert from 'node:assert/strict';

// collections

test('an array keeps what you put in it, in order', () => {
  const items: string[] = ['a', 'b'];

  items.push('c');

  assert.deepEqual(items, ['a', 'b', 'c']);
  assert.equal(items.length, 3);
  assert.deepEqual(items.slice(1, 3), ['b', 'c']);
});

test('a lookup for a key that is not there comes back empty', () => {
  const counts = new Map<string, number>([
    ['a', 2],
    ['b', 1],
  ]);

  assert.equal(counts.get('a'), 2);
  assert.equal(counts.get('z'), undefined);
  assert.equal(counts.get('z') ?? 0, 0);
});

test('a set discards duplicates', () => {
  const letters = new Set<string>(['a', 'b', 'a']);

  assert.equal(letters.size, 2);
  assert.ok(letters.has('a'));
  assert.deepEqual([...letters], ['a', 'b']);
});

// strings

test('a string splits into parts and joins back up', () => {
  const words = 'one two three'.split(' ');

  assert.deepEqual(words, ['one', 'two', 'three']);
  assert.equal(words.join('-'), 'one-two-three');
});

test('a slice of a string counts from zero', () => {
  const text = 'abcdef';

  assert.equal(text[0], 'a');
  assert.equal(text.slice(0, 3), 'abc');
  assert.equal(text.slice(-2), 'ef');
});

test('text can be built up by interpolation', () => {
  const label = 'batch';
  const count = 2;

  assert.equal(`${label} x${count}`, 'batch x2');
  assert.equal('ab'.repeat(3), 'ababab');
  assert.equal('  padded  '.trim(), 'padded');
});

// types and branching

test('a type groups related fields under one name', () => {
  type Point = { x: number; y: number };
  const point: Point = { x: 1, y: 2 };

  const moved: Point = { ...point, x: 5 };

  assert.deepEqual(moved, { x: 5, y: 2 });
  assert.deepEqual(point, { x: 1, y: 2 });
});

test('a union of named states can be matched exhaustively', () => {
  // The default branch assigns the unmatched value to a `never`, so adding a
  // third state without a case for it fails to compile instead of at runtime.
  type State = 'locked' | 'open';
  const toggle = (state: State): State => {
    switch (state) {
      case 'locked':
        return 'open';
      case 'open':
        return 'locked';
      default: {
        const unreachable: never = state;
        return unreachable;
      }
    }
  };

  assert.equal(toggle('locked'), 'open');
  assert.equal(toggle('open'), 'locked');
});

test('a branch can produce a value instead of setting one', () => {
  const describe = (n: number): string =>
    n < 0 ? 'negative' : n === 0 ? 'zero' : 'positive';

  assert.equal(describe(-1), 'negative');
  assert.equal(describe(0), 'zero');
  assert.equal(describe(1), 'positive');
});

// iteration

test('a loop can read both the position and the item', () => {
  const seen: string[] = [];

  for (let i = 0; i < ['a', 'b'].length; i += 1) {
    seen.push(`${i}:${['a', 'b'][i]}`);
  }

  assert.deepEqual(seen, ['0:a', '1:b']);
});

test('a sequence can be walked two items at a time', () => {
  const values = [1, 2, 3, 4];
  const sums: number[] = [];

  for (let i = 0; i < values.length - 1; i += 1) {
    sums.push(values[i] + values[i + 1]);
  }

  assert.deepEqual(sums, [3, 5, 7]);
});

// functions

test('a function can be handed to another function', () => {
  const square = (n: number): number => n * n;

  const squared = [1, 2, 3].map(square);
  const positive = [-1, 0, 1].filter((n) => n > 0);

  assert.deepEqual(squared, [1, 4, 9]);
  assert.deepEqual(positive, [1]);
});

test('a list can be folded down to a single value', () => {
  const values = [1, 2, 3, 4];

  const total = values.reduce((sum, n) => sum + n, 0);

  assert.equal(total, 10);
});

// errors

test('an index outside the collection is refused rather than wrapped', () => {
  class OutOfRangeError extends Error {
    readonly value: number;

    constructor(value: number) {
      super(`out of range: ${value}`);
      this.value = value;
    }
  }
  const checkedIndex = (value: number, length: number): number => {
    if (value < 0 || value >= length) {
      throw new OutOfRangeError(value);
    }
    return value;
  };

  assert.equal(checkedIndex(2, 5), 2);
  assert.throws(() => checkedIndex(-1, 5), OutOfRangeError);
  assert.throws(() => checkedIndex(5, 5), /out of range/);
});

// gotchas

test('a type assertion changes what the compiler believes, not what is there', () => {
  const payload = '{"count": "nope"}';

  const parsed = JSON.parse(payload) as { count: number };

  assert.equal(typeof parsed.count, 'string');
  assert.notEqual(typeof parsed.count, 'number');
});
