<?php

declare(strict_types=1);

namespace Greeting;

function greet(string $name): string
{
    return "Hello, {$name}!";
}
