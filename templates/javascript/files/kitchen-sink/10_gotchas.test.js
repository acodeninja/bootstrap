import { describe, it } from 'node:test';
import assert from 'node:assert/strict';

// Six things that bite people arriving from another language. Each one pairs
// the surprise with the spelling you should actually use.

describe('floats do not add up', () => {
  it('0.1 + 0.2 is not 0.3', () => {
    assert.notEqual(0.1 + 0.2, 0.3);
    assert.equal(0.1 + 0.2, 0.30000000000000004);
  });

  it('compare within a tolerance instead', () => {
    const difference = Math.abs(0.1 + 0.2 - 0.3);

    assert.ok(difference < Number.EPSILON);
  });
});

describe('typeof null', () => {
  it('reports object, which is a bug old enough to be permanent', () => {
    assert.equal(typeof null, 'object');
  });

  it('test for null directly', () => {
    const value = null;

    assert.ok(value === null);
    assert.equal(value ?? 'fallback', 'fallback');
  });
});

describe('loose equality coerces', () => {
  const surprises = [
    ['an empty array equals false', [], false],
    ['an empty string equals zero', '', 0],
    ['a numeric string equals its number', '1', 1],
  ];

  for (const [label, left, right] of surprises) {
    it(label, () => {
      assert.ok(left == right);
      assert.ok(!(left === right));
    });
  }

  it('null and undefined equal each other and nothing else', () => {
    const cleared = null;
    const missing = undefined;
    const zero = 0;

    assert.ok(cleared == missing);
    assert.ok(!(cleared == zero));
  });
});

describe('sort is lexicographic', () => {
  it('sorts numbers as if they were strings', () => {
    const sorted = [10, 9, 1].sort();

    assert.deepEqual(sorted, [1, 10, 9]);
  });

  it('pass a comparator to sort numerically', () => {
    const sorted = [10, 9, 1].sort((a, b) => a - b);

    assert.deepEqual(sorted, [1, 9, 10]);
  });

  it('sort mutates the array it was given, toSorted does not', () => {
    const original = [10, 9, 1];

    const copy = original.toSorted((a, b) => a - b);
    original.sort((a, b) => a - b);

    assert.deepEqual(copy, [1, 9, 10]);
    assert.deepEqual(original, [1, 9, 10]);
  });
});

describe('NaN', () => {
  it('is the only value not equal to itself', () => {
    const notANumber = Number('banana');
    const alsoNotANumber = notANumber;

    assert.ok(notANumber !== alsoNotANumber);
  });

  it('needs Number.isNaN, and indexOf cannot find it', () => {
    const values = [1, Number('banana'), 3];

    assert.ok(Number.isNaN(values[1]));
    assert.equal(values.indexOf(Number('banana')), -1);
    assert.equal(values.findIndex(Number.isNaN), 1);
  });
});

describe('const is not immutability', () => {
  it('a const array still accepts push', () => {
    const items = [1, 2];

    items.push(3);

    assert.deepEqual(items, [1, 2, 3]);
  });

  it('Object.freeze is shallow', () => {
    const config = Object.freeze({ nested: { debug: false } });

    config.nested.debug = true;

    assert.equal(config.nested.debug, true);
  });
});
