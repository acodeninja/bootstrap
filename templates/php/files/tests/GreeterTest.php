<?php

declare(strict_types=1);

namespace Tests;

use PHPUnit\Framework\TestCase;

// `require` loads a file; `use` imports a name. Both are needed and they do
// different jobs -- there is no autoloader in this project, so nothing would
// find the greeter's file without the first line, and nothing would shorten
// Greeting\greet to greet without the second.
//
// `use function` is the form for a function. A bare `use` imports a class, and
// using it here would silently import a class that does not exist.
require __DIR__ . '/../src/{{PROJECT_SNAKE}}.php';

use function Greeting\greet;

// Nothing names this file. PHPUnit is pointed at tests/ by phpunit.xml and takes
// every class extending TestCase, so a test is found by existing and deleting
// one is safe. Run the suite with `make test`.
//
// `final` because nothing should subclass a test. The class name has to end in
// Test for PHPUnit's default file matching to pick the file up.
final class GreeterTest extends TestCase
{
    // A public method whose name begins with `test` is a test, and that is the
    // whole registration -- no attribute, no annotation. The name is camel case
    // because it is an identifier, and it is what a failure prints.
    //
    // `: void` because a test returns nothing, and strict_types above means
    // that is checked.
    public function testAGreetingAddressesTheNameItIsGiven(): void
    {
        // Arrange, act, assert, separated by blank lines.
        $name = 'world';

        $greeting = greet($name);

        // assertSame, not assertEquals: assertEquals compares loosely, so it
        // would pass for values that merely look alike. Expected first, actual
        // second -- swapping them still passes and only makes the failure
        // message name the wrong side.
        $this->assertSame('Hello, world!', $greeting);
    }
}
