// A file-scoped namespace: the semicolon form puts everything after it in
// Greeting, with no braces and no indentation. The older form wraps the file in
// a block instead, and both are still legal.
//
// The namespace is not the filename and not the folder. This file is named after
// the project; the namespace is what callers write, and the SDK's default
// **/*.cs include is what gets it compiled -- nothing lists this file anywhere.
namespace Greeting;

// `static` on a class means it holds no state and cannot be instantiated, which
// is how C# spells a module of functions. `public` is what makes it visible
// outside this assembly; the default without it is `internal`.
public static class Greeter
{
    // Every method lives on a class -- there are no free functions. `static`
    // again, so callers write Greeter.Greet(name) rather than making one.
    //
    // The return type comes before the name, the parameter type before its
    // name, and `=>` is an expression-bodied member: shorthand for a body that
    // is one expression, with no `return` and no braces.
    //
    // $"..." is an interpolated string and the $ is what makes it one. Without
    // it the braces are just characters, which no test of the length notices.
    public static string Greet(string name) => $"Hello, {name}!";
}
