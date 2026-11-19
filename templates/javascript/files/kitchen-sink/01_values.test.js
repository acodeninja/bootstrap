import { describe, it } from 'node:test';
import assert from 'node:assert/strict';

describe('bindings', () => {
  it('let rebinds', () => {
    const seen = [];
    let counter = 1;

    seen.push(counter);
    counter = 2;
    seen.push(counter);

    assert.deepEqual(seen, [1, 2]);
  });

  it('const freezes the binding but not the object', () => {
    const settings = { retries: 1 };

    settings.retries = 3;

    assert.equal(settings.retries, 3);
  });

  it('Object.freeze is what stops the mutation', () => {
    const settings = Object.freeze({ retries: 1 });

    assert.throws(() => {
      settings.retries = 3;
    }, TypeError);
    assert.equal(settings.retries, 1);
  });

  it('an inner block shadows rather than overwrites', () => {
    const scope = 'outer';
    let seen;

    {
      const scope = 'inner';
      seen = scope;
    }

    assert.equal(seen, 'inner');
    assert.equal(scope, 'outer');
  });
});

// JavaScript has no type annotations. typeof is the only answer to "what is
// this", and it is a runtime one.
describe('typeof', () => {
  const cases = [
    ['a number', 42, 'number'],
    ['a bigint', 9007199254740993n, 'bigint'],
    ['a string', 'text', 'string'],
    ['a boolean', true, 'boolean'],
    ['undefined', undefined, 'undefined'],
    ['a symbol', Symbol('tag'), 'symbol'],
    ['a plain object', {}, 'object'],
    ['an array', [], 'object'],
    ['a function', () => {}, 'function'],
  ];

  for (const [label, value, expected] of cases) {
    it(`reports ${expected} for ${label}`, () => {
      assert.equal(typeof value, expected);
    });
  }

  it('cannot tell an array from an object, so Array.isArray exists', () => {
    assert.equal(typeof [], typeof {});
    assert.ok(Array.isArray([]));
    assert.ok(!Array.isArray({}));
  });
});

describe('absence', () => {
  it('undefined is absence the runtime produced', () => {
    const record = {};

    assert.equal(record.missing, undefined);
  });

  it('null is absence a human wrote down', () => {
    const record = { value: null };

    assert.equal(record.value, null);
    assert.notEqual(record.value, undefined);
  });

  it('nullish coalescing treats both as absent, and zero as present', () => {
    const cleared = null;
    const missing = undefined;
    const zero = 0;

    assert.equal(cleared ?? 'fallback', 'fallback');
    assert.equal(missing ?? 'fallback', 'fallback');
    assert.equal(zero ?? 'fallback', 0);
  });

  it('optional chaining short-circuits instead of throwing', () => {
    const record = { nested: null };

    assert.equal(record.nested?.deep, undefined);
    assert.equal(record.absent?.deep, undefined);
  });
});
