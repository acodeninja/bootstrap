import { test } from 'node:test';
import assert from 'node:assert/strict';

test('a constant can be changed from the inside', () => {
  const rolls = [10, 7];

  rolls.push(3);

  assert.deepEqual(rolls, [10, 7, 3]);
});

test('a property that was never set reads as empty', () => {
  const pinsByFrame = { 1: 10 };

  assert.equal(pinsByFrame[2], undefined);
});

test('a value set to nothing is not the same as a value never set', () => {
  const frame = { first: 4, second: null };

  assert.equal(frame.second, null);
  assert.equal(frame.third, undefined);
  assert.notEqual(frame.second, frame.third);
});

test('a fallback applies to missing values but not to zero', () => {
  const scores = { alice: 0 };

  assert.equal(scores.alice ?? 100, 0);
  assert.equal(scores.bob ?? 100, 100);
  assert.equal(scores.alice || 100, 100);
});

test('a list does not report itself as a list', () => {
  const rolls = [10, 7];

  assert.equal(typeof rolls, 'object');
  assert.ok(Array.isArray(rolls));
});
