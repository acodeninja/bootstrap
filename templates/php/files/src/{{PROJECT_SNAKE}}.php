<?php

// strict_types changes what the type declarations below mean, and it is per
// file: without it PHP coerces, so greet(5) would quietly become "5"; with it
// the call is a TypeError. Declare it in every file -- it is the single most
// useful line in modern PHP, and it has to be the first statement.
declare(strict_types=1);

// A namespace, and it is not the filename: this file is named after the project
// and callers write Greeting\greet. There is no autoloader configured here, so
// the test requires the file by path and then imports the function by name.

namespace Greeting;

// A free function, which PHP has -- there is no class to hang this on. Nothing
// marks it exported: everything in a namespace is reachable from outside it.
//
// The parameter type comes before the name and the return type after a colon.
// Both are optional in PHP and neither should be left out.
function greet(string $name): string
{
    // "..." interpolates and '...' does not, which is the opposite way round
    // from the quote styles in several other languages here. The braces in
    // {$name} are optional for a plain variable and required the moment the
    // expression is anything more, so writing them always is the safer habit.
    return "Hello, {$name}!";
}
