// One import, and that is deliberate rather than minimal. `gleam format` sorts a
// module's imports, so a file with two of them has exactly one correct order --
// and which one depends on how the project's name sorts against the other. That
// made the obvious arrangement pass for about half of all project names, so the
// suite entry module imports gleeunit alone and this file imports the project
// alone. Nothing here has two imports to order.
import {{PROJECT_SNAKE}}

// The registration is the `_test` suffix on the *function* name. gleeunit globs
// test/ at run time and runs every exported function ending that way, so a test
// is found by being named -- the filename suffix is convention only, and this
// file could be called anything.
//
// Gleam identifiers cannot contain spaces and there is no annotation to carry a
// sentence, so the name is snake case and reads as closely to one as it can. It
// is what a failure prints.
pub fn a_greeting_addresses_the_name_it_is_given_test() {
  // Arrange, act, assert, separated by blank lines. `let` binds and does not
  // reassign: there is no mutation in the language, so a second `let` with the
  // same name shadows the first rather than changing it.
  let name = "world"

  let greeting = {{PROJECT_SNAKE}}.greet(name)

  // `assert` on an ordinary expression. The compiler knows what the comparison
  // was, so a failure prints both sides -- which is why there is no
  // assert_equal to learn and no expected-first order to remember.
  assert greeting == "Hello, world!"
}
