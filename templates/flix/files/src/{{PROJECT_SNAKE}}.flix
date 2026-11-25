// There is no module declaration and no namespace, so `greet` lives in the root
// and the test calls it bare. `pub` is what makes it visible outside this file;
// without it the function is private to the file.
//
// The types are not optional: Flix infers inside a function body but every
// top-level definition declares its signature, and the one here says String in,
// String out.
//
// What is not written is the interesting part. A Flix signature can also carry
// an effect after a backslash -- `\ IO`, `\ Assert` -- and this one carries
// none, which makes the function pure: it cannot print, throw, or read a
// reference. The test beside this file is `\ Assert` for exactly that reason.
//
// ${name} interpolates inside a string literal.
pub def greet(name: String): String = "Hello, ${name}!"
