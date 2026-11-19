import 'package:test/test.dart';

import '../src/{{PROJECT_SNAKE}}.dart';

void main() {
  test('a greeting addresses the name it is given', () {
    const name = 'world';

    final greeting = greet(name);

    expect(greeting, equals('Hello, world!'));
  });
}
