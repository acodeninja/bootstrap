// package:test is a dependency rather than part of the SDK, declared in
// pubspec.yaml -- the `package:` prefix is how you import from one, where a
// relative path imports a file of your own.
import 'package:test/test.dart';

// A relative path, because the greeter is a file in this project rather than a
// package. There is no extension to leave off: a Dart import names the file.
import '../src/{{PROJECT_SNAKE}}.dart';

// Every test file is a program and `main` is where it starts. The runner calls
// this function, and the `test(...)` calls inside it register as they execute --
// so a test is registered by being reached, not by being annotated.
//
// Nothing names this file. `dart test` walks test/ for files ending in
// _test.dart, so a new one is found by existing and deleting one is safe. Run
// the suite with `make test`.
void main() {
  // The first argument is the name. It is printed on failure with nothing
  // around it, so it is written as a sentence that reads on its own.
  test('a greeting addresses the name it is given', () {
    // Arrange, act, assert, separated by blank lines. `const` is known when you
    // compile and `final` is assigned once while you run -- both immutable, and
    // the difference is only when the value is settled.
    const name = 'world';

    final greeting = greet(name);

    // expect takes the actual value first and a matcher second. `equals(...)`
    // is the matcher; the bare string works too, because expect wraps anything
    // that is not already a matcher in equals for you.
    expect(greeting, equals('Hello, world!'));
  });
}
