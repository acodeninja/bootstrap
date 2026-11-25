// A module declaration, and the name should match the file path -- this one
// carries the project name. D has four comment forms: // to end of line, the
// C-style pair, and /+ +/ which nests, plus /// for documentation.
module {{PROJECT_SNAKE}};

// `import std.format : format;` is a selective import: it brings in that one
// symbol rather than the whole module, which keeps the namespace small and the
// compile fast. A bare `import std.format;` would work too.
import std.format : format;

/// Returns a greeting addressed to `name`.
///
/// Three slashes make a documentation comment, and here it is not optional:
/// `make lint` runs dscanner with its style checks, which asks for one on
/// every public declaration. Nothing marks this public, because public is the
/// default -- `private` is what you write when you mean it.
string greet(string name)
{
    // format! with an exclamation mark passes the format string as a template
    // argument rather than a runtime one, so the compiler checks it against the
    // arguments and a mismatched %s does not build. The runtime form,
    // format("...", name), compiles and fails later.
    return format!"Hello, %s!"(name);
}

// The test lives in the same file, which is D's own idiom rather than a
// compromise: `unittest` is a language construct, and the compiler only emits
// these blocks when built with -unittest, so none of this reaches a release
// binary. There is no test/ directory in this template at all.
//
// The string in @(...) is a user-defined attribute, which the test runner reads
// as the name -- so a test name can be a real sentence. It is what a failure
// prints. `dub test` runs every unittest block it compiles, so a test is found
// by existing and deleting one is safe. Run them with `make test`.
@("a greeting addresses the name it is given")
unittest
{
    // `const` is a binding that cannot be changed through this name. `immutable`
    // is the stronger one, promising the value is unchangeable by anybody.
    const greeting = greet("world");

    // A bare `assert`, which is the language rather than a library. There is no
    // assertEquals and no expected-first order to remember; the cost is that a
    // failure reports the expression rather than both values, so a comparison
    // worth debugging gets a message as its second argument.
    assert(greeting == "Hello, world!");
}
