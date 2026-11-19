import { describe, it } from 'node:test';
import assert from 'node:assert/strict';

// JavaScript signals failure by throwing. Anything can be thrown, but an Error
// subclass is what carries a stack and survives instanceof.
class ValidationError extends Error {
  constructor(message, field) {
    super(message);
    this.name = 'ValidationError';
    this.field = field;
  }
}

const parseAge = (input) => {
  const age = Number(input);

  if (!Number.isInteger(age)) {
    throw new ValidationError(
      `age must be a whole number, got "${input}"`,
      'age',
    );
  }
  if (age < 0) {
    throw new ValidationError('age must not be negative', 'age');
  }

  return age;
};

describe('throwing', () => {
  it('returns the value when the input is valid', () => {
    assert.equal(parseAge('41'), 41);
  });

  it('throws a typed error the caller can match on', () => {
    assert.throws(() => parseAge('tomorrow'), ValidationError);
  });

  it('carries context the handler can read', () => {
    try {
      parseAge('-1');
      assert.fail('expected parseAge to throw');
    } catch (error) {
      assert.ok(error instanceof ValidationError);
      assert.ok(error instanceof Error);
      assert.equal(error.field, 'age');
    }
  });

  it('matches the message with a regexp or a shape', () => {
    assert.throws(() => parseAge('x'), /whole number/);
    assert.throws(() => parseAge('x'), {
      name: 'ValidationError',
      field: 'age',
    });
  });
});

describe('catching', () => {
  it('finally runs whether or not the body threw', () => {
    const order = [];

    try {
      order.push('try');
      throw new Error('boom');
    } catch {
      order.push('catch');
    } finally {
      order.push('finally');
    }

    assert.deepEqual(order, ['try', 'catch', 'finally']);
  });

  it('rethrowing lets a handler pass on what it does not own', () => {
    const loadProfile = (input) => {
      try {
        return parseAge(input);
      } catch (error) {
        if (error instanceof ValidationError) {
          throw error;
        }
        throw new Error('could not load the profile', { cause: error });
      }
    };

    assert.throws(() => loadProfile('x'), ValidationError);
    assert.equal(loadProfile('41'), 41);
  });

  it('cause records what a wrapping error was caused by', () => {
    const wrap = () => {
      try {
        parseAge('x');
      } catch (error) {
        throw new Error('could not load the profile', { cause: error });
      }
    };

    assert.throws(wrap, (error) => {
      assert.equal(error.message, 'could not load the profile');
      assert.ok(error.cause instanceof ValidationError);
      return true;
    });
  });
});

describe('async failure', () => {
  it('a rejected promise is the async spelling of throw', async () => {
    const loadAge = async (input) => parseAge(input);

    await assert.rejects(loadAge('x'), ValidationError);
    assert.equal(await loadAge('41'), 41);
  });
});
