<?php

declare(strict_types=1);

namespace Tests;

use PHPUnit\Framework\TestCase;

require __DIR__ . '/../src/{{PROJECT_SNAKE}}.php';

use function Greeting\greet;

final class GreeterTest extends TestCase
{
    public function testAGreetingAddressesTheNameItIsGiven(): void
    {
        $name = 'world';

        $greeting = greet($name);

        $this->assertSame('Hello, world!', $greeting);
    }
}
