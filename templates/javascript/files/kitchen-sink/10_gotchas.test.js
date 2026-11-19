import { test } from 'node:test';
import assert from 'node:assert/strict';

test('adding two tenths does not give three tenths', () => {
  const sum = 0.1 + 0.2;

  assert.notEqual(sum, 0.3);
  assert.ok(Math.abs(sum - 0.3) < Number.EPSILON);
});

test('sorting numbers puts 10 before 9', () => {
  const scores = [10, 9, 1];

  const byDefault = [...scores].sort();
  const byValue = [...scores].sort((a, b) => a - b);

  assert.deepEqual(byDefault, [1, 10, 9]);
  assert.deepEqual(byValue, [1, 9, 10]);
});

test('an empty string counts as zero when compared loosely', () => {
  const blank = '';
  const zero = 0;

  assert.ok(blank == zero);
  assert.ok(!(blank === zero));
});

test('not-a-number does not equal itself', () => {
  const parsed = Number('strike');
  const copy = parsed;

  assert.ok(parsed !== copy);
  assert.ok(Number.isNaN(parsed));
});

test('null reports its type as object', () => {
  const nothing = null;

  assert.equal(typeof nothing, 'object');
  assert.ok(nothing === null);
});
