import { test } from 'node:test';
import assert from 'node:assert/strict';

class InvalidRoll extends Error {
  constructor(message) {
    super(message);
    this.name = 'InvalidRoll';
  }
}

const parseRoll = (input) => {
  const pins = Number(input);

  if (!Number.isInteger(pins)) {
    throw new InvalidRoll(`not a number: "${input}"`);
  }
  if (pins < 0 || pins > 10) {
    throw new InvalidRoll(`out of range: ${pins}`);
  }

  return pins;
};

test('a valid input comes back unchanged', () => {
  assert.equal(parseRoll('7'), 7);
});

test('an invalid input is refused rather than guessed at', () => {
  assert.throws(() => parseRoll('strike'));
});

test('a refusal says what was wrong', () => {
  assert.throws(() => parseRoll('strike'), /not a number/);
  assert.throws(() => parseRoll('11'), /out of range/);
});

test('a custom failure type lets the caller tell one problem from another', () => {
  assert.throws(() => parseRoll('11'), InvalidRoll);
  assert.throws(() => parseRoll('11'), Error);
});

test('catching a failure lets the caller carry on', () => {
  const readRoll = (input) => {
    try {
      return parseRoll(input);
    } catch {
      return 0;
    }
  };

  assert.equal(readRoll('7'), 7);
  assert.equal(readRoll('strike'), 0);
});
