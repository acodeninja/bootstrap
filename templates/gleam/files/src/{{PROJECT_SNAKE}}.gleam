// `pub` is what makes this reachable from another module; without it the
// function is private to this file, and that is the whole of Gleam's visibility.
//
// The module name is the file's path under src/, so this one is named after the
// project and the test imports it by that name. Nothing lists the file.
//
// The types are not optional decoration and they are not quite required either:
// Gleam infers them, and the convention is to write them on anything public so
// that a change to the body cannot quietly change the signature.
pub fn greet(name: String) -> String {
  // <> concatenates two strings, and it is the only way to build one here:
  // Gleam has no string interpolation at all. A longer piece of text is either
  // a chain of these or a call into the string_builder module.
  //
  // There is no `return` either. The last expression in a function is its
  // value, which is true of every block in the language.
  "Hello, " <> name <> "!"
}
