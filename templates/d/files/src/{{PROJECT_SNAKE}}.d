module {{PROJECT_SNAKE}};

import std.format : format;

/// Returns a greeting addressed to `name`.
string greet(string name)
{
    return format!"Hello, %s!"(name);
}

@("a greeting addresses the name it is given")
unittest
{
    const greeting = greet("world");

    assert(greeting == "Hello, world!");
}
