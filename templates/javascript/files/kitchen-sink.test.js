import { test } from 'node:test';
import assert from 'node:assert/strict';

// collections

test('a list keeps what you put in it, in order', () => {
  const items = ['a', 'b'];

  items.push('c');

  assert.deepEqual(items, ['a', 'b', 'c']);
  assert.equal(items.length, 3);
  assert.deepEqual(items.slice(1, 3), ['b', 'c']);
});

test('a lookup for a key that is not there comes back empty', () => {
  const counts = new Map([
    ['a', 2],
    ['b', 1],
  ]);

  assert.equal(counts.get('a'), 2);
  assert.equal(counts.get('z'), undefined);
  assert.equal(counts.get('z') ?? 0, 0);
});

test('a set discards duplicates', () => {
  const letters = new Set(['a', 'b', 'a']);

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
  const name = 'world';
  const count = 2;

  assert.equal(`${name} x${count}`, 'world x2');
  assert.equal('ab'.repeat(3), 'ababab');
  assert.equal('  padded  '.trim(), 'padded');
});

// types and branching

test('a record groups related fields under one name', () => {
  const point = { x: 1, y: 2 };

  const moved = { ...point, x: 5 };

  assert.deepEqual(moved, { x: 5, y: 2 });
  assert.deepEqual(point, { x: 1, y: 2 });
});

test('a fixed set of named states can be matched one by one', () => {
  // JavaScript has no exhaustive match, and nothing checks you covered every
  // state. A lookup table makes the cases obvious, and the fallback is yours
  // to remember.
  const nextState = { locked: 'open', open: 'locked' };

  assert.equal(nextState.locked, 'open');
  assert.equal(nextState.open, 'locked');
  assert.equal(nextState.broken ?? 'unknown', 'unknown');
});

test('a branch can produce a value instead of setting one', () => {
  const describe = (n) => (n < 0 ? 'negative' : n === 0 ? 'zero' : 'positive');

  assert.equal(describe(-1), 'negative');
  assert.equal(describe(0), 'zero');
  assert.equal(describe(1), 'positive');
});

// iteration

test('a loop can read both the position and the item', () => {
  const seen = [];

  for (const [index, item] of ['a', 'b'].entries()) {
    seen.push(`${index}:${item}`);
  }

  assert.deepEqual(seen, ['0:a', '1:b']);
});

test('a sequence can be walked two items at a time', () => {
  const values = [1, 2, 3, 4];
  const pairs = [];

  for (let i = 0; i < values.length - 1; i += 1) {
    pairs.push(values[i] + values[i + 1]);
  }

  assert.deepEqual(pairs, [3, 5, 7]);
});

// functions

test('a function can be handed to another function', () => {
  const double = (n) => n * 2;

  const doubled = [1, 2, 3].map(double);
  const big = [1, 2, 3].filter((n) => n > 1);

  assert.deepEqual(doubled, [2, 4, 6]);
  assert.deepEqual(big, [2, 3]);
});

test('a list can be folded down to a single value', () => {
  const values = [1, 2, 3, 4];

  const total = values.reduce((sum, n) => sum + n, 0);

  assert.equal(total, 10);
});

// errors

test('an invalid input is refused rather than guessed at', () => {
  const parsePercentage = (input) => {
    const value = Number(input);

    if (!Number.isInteger(value) || value < 0 || value > 100) {
      throw new RangeError(`not a percentage: "${input}"`);
    }

    return value;
  };

  assert.equal(parsePercentage('40'), 40);
  assert.throws(() => parsePercentage('half'), RangeError);
  assert.throws(() => parsePercentage('140'), /not a percentage/);
});

// gotchas

test('sorting numbers puts 10 before 9', () => {
  const values = [10, 9, 1];

  const byDefault = [...values].sort();
  const byValue = [...values].sort((a, b) => a - b);

  assert.deepEqual(byDefault, [1, 10, 9]);
  assert.deepEqual(byValue, [1, 9, 10]);
});
