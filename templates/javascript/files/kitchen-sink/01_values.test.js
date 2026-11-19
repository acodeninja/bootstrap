import { test } from 'node:test';
import assert from 'node:assert/strict';

test('a constant can be changed from the inside', () => {
  const items = ['a', 'b'];

  items.push('c');

  assert.deepEqual(items, ['a', 'b', 'c']);
});

test('a property that was never set reads as empty', () => {
  const counts = { a: 2 };

  assert.equal(counts.b, undefined);
});

test('a value set to nothing is not the same as a value never set', () => {
  const record = { first: 'x', second: null };

  assert.equal(record.second, null);
  assert.equal(record.third, undefined);
  assert.notEqual(record.second, record.third);
});

test('a fallback applies to missing values but not to zero', () => {
  const settings = { retries: 0 };

  assert.equal(settings.retries ?? 3, 0);
  assert.equal(settings.timeout ?? 3, 3);
  assert.equal(settings.retries || 3, 3);
});

test('a list does not report itself as a list', () => {
  const items = ['a', 'b'];

  assert.equal(typeof items, 'object');
  assert.ok(Array.isArray(items));
});
