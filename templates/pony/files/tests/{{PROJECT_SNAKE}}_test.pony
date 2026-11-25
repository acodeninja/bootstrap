// `use` brings in a package by name. pony_test is the standard library's own
// framework, and "src" is a path -- a Pony package is a directory, so this
// imports the project's whole src/ rather than one file in it.
use "pony_test"
use "src"

// The declaration below has to stay exactly as it is: one line, starting at
// column 0, `class iso <Name> is UnitTest`. This project generates its test
// harness by scanning tests/*.pony for that shape, so wrapping or re-indenting
// this line makes the test silently stop running while the suite still passes.
// A comment above it is fine, which is where this one is.
//
// `iso` is a reference capability, and on a class declaration it says every
// reference to this is isolated -- nobody else can see it, so the test harness
// may hand it to another actor safely. Capabilities are the reason Pony needs no
// locks, and this line is the first one you meet.
class iso TestGreeting is UnitTest
  // The name is a method rather than a string literal or an annotation, so it
  // is computed -- which is Pony having no reflection and no metadata to read.
  // It is what a failure prints, so write it to read on its own.
  fun name(): String => "a greeting names whoever it is given"

  // `apply` is the test body, and the name is not arbitrary: a type with an
  // `apply` method can be called like a function, which is how the harness runs
  // it. TestHelper is how a test reports -- there is no global assert.
  fun apply(h: TestHelper) =>
    // `let` binds once and cannot be rebound; `var` is the reassignable one.
    let greeting = Greeter.greet("world")

    // The square brackets are a type argument: assert_eq is generic, and Pony
    // asks you to say which type you are comparing rather than inferring it
    // here. Expected first, actual second.
    h.assert_eq[String]("Hello, world!", greeting)
