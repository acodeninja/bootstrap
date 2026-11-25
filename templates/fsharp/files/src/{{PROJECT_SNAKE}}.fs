// A module declaration, and it has to be the first thing in the file. The module
// is Greeting whatever the file is called -- this one is named after the
// project -- and callers reach the function below as Greeting.greet.
//
// Order matters here in a way it does not in most languages: the .fsproj lists
// its source files, F# compiles them in that order, and a module may only use
// what an earlier file already defined. Alphabetical is not it; the list is.
module Greeting

// `let` binds everything -- values, functions, the lot. A function is a value
// with parameters, so there is no `fun` keyword to look for and nothing marks
// this as exported: every name in a module is public unless you say otherwise.
//
// There are no type annotations and they are not missing. F# infers that `name`
// is a string because the interpolated string demands one, and infers the return
// type from the body. Annotating would be legal and is usually noise.
//
// $"..." is an interpolated string; the $ is what makes the braces mean
// anything.
let greet name = $"Hello, {name}!"
