// Both of these are in the runtime. There is no test framework to install, and
// the `node:` prefix is what tells the resolver to use the built-in rather than
// a package that happens to share the name.
//
// node:assert/strict rather than node:assert: the strict variant makes `equal`
// compare with === instead of ==, which is the comparison you want every time.
import { test } from 'node:test';
import assert from 'node:assert/strict';

// The literal .ts extension, which looks wrong and is not. Node resolves by path
// and runs TypeScript by stripping its types, so the file it loads really is
// this one -- tsconfig.json carries allowImportingTsExtensions to let `tsc`
// accept the spelling.
import { greet } from './{{PROJECT_SNAKE}}.ts';

// Nothing names this file. `make test` is a bare `node --test`, which walks the
// tree itself for files matching *.test.ts -- so a new test file is found by
// existing, and deleting one is safe. Handing node --test a path would make it
// load that path as a module and exit 1 even with every assertion passing.
//
// The first argument is the name. It is printed on failure with nothing around
// it, so it is written as a sentence that reads on its own.
test('a greeting addresses the name it is given', () => {
  // Arrange, act, assert, separated by blank lines. Every test in this project
  // has those three parts in that order.
  const name = 'world';

  const greeting = greet(name);

  // Actual first here, expected second -- the opposite order to most assertion
  // libraries. Getting it the wrong way round still passes; it only makes the
  // failure message name the wrong side as the problem.
  assert.equal(greeting, 'Hello, world!');
});
