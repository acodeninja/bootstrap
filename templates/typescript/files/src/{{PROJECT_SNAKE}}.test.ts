import { test } from 'node:test';
import assert from 'node:assert/strict';

import { greet } from './{{PROJECT_SNAKE}}.ts';

test('a greeting addresses the name it is given', () => {
  const name = 'world';

  const greeting = greet(name);

  assert.equal(greeting, 'Hello, world!');
});
