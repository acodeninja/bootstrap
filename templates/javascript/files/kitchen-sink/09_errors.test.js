import { test } from 'node:test';
import assert from 'node:assert/strict';

class InvalidPercentage extends Error {
  constructor(message) {
    super(message);
    this.name = 'InvalidPercentage';
  }
}

const parsePercentage = (input) => {
  const value = Number(input);

  if (!Number.isInteger(value)) {
    throw new InvalidPercentage(`not a number: "${input}"`);
  }
  if (value < 0 || value > 100) {
    throw new InvalidPercentage(`out of range: ${value}`);
  }

  return value;
};

test('a valid input comes back unchanged', () => {
  assert.equal(parsePercentage('40'), 40);
});

test('an invalid input is refused rather than guessed at', () => {
  assert.throws(() => parsePercentage('half'));
});

test('a refusal says what was wrong', () => {
  assert.throws(() => parsePercentage('half'), /not a number/);
  assert.throws(() => parsePercentage('140'), /out of range/);
});

test('a custom failure type lets the caller tell one problem from another', () => {
  assert.throws(() => parsePercentage('140'), InvalidPercentage);
  assert.throws(() => parsePercentage('140'), Error);
});

test('catching a failure lets the caller carry on', () => {
  const read = (input) => {
    try {
      return parsePercentage(input);
    } catch {
      return 0;
    }
  };

  assert.equal(read('40'), 40);
  assert.equal(read('half'), 0);
});
