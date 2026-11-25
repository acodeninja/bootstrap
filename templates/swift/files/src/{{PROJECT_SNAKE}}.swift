// `public` is what makes this reachable from another module -- the test target
// is one, so without it the test would not compile. The default is `internal`:
// visible everywhere in this module and nowhere outside it.
//
// This is a free function. Swift has them, unlike Java or C#, so a module of
// functions needs no class or struct to hang them on.
//
// The underscore before `name` suppresses the argument label. Swift callers
// normally name their arguments -- greet(name: "world") -- and `_` is how you
// say this one reads better without it. The parameter type comes after a colon
// and the return type after an arrow.
public func greet(_ name: String) -> String {
  // No `return`. A function whose body is a single expression returns it
  // implicitly, which Swift 5.1 added and which is why there is nothing here
  // but the string.
  //
  // \(name) is interpolation. The backslash form is Swift's own, where most
  // languages use a dollar sign or braces alone.
  "Hello, \(name)!"
}
