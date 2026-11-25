// A `primitive` is a type with exactly one instance and no fields, which is how
// Pony spells a module of functions -- there is nothing to construct and nothing
// to hold. A `class` would need a constructor and an allocation; an `actor`
// would additionally get its own mailbox and run concurrently.
//
// Nothing marks this exported. Everything in a Pony package is visible to the
// rest of it, and a leading underscore is what makes a name private to the
// package -- so visibility is per package rather than per file.
primitive Greeter
  // `fun` declares a function. The parameter type comes after a colon and the
  // return type after the parentheses, and `=>` separates the signature from
  // the body -- there is no `return`, because the body is an expression.
  //
  // What is absent here is the thing to notice. A Pony function may carry a
  // receiver capability -- `fun ref`, `fun box`, `fun iso` -- saying what it may
  // do to the instance it is called on, and may end with `?` to declare that it
  // can fail. This one has neither: it reads nothing and cannot refuse.
  fun greet(name: String): String =>
    // + concatenates strings, and it has to: Pony has no interpolation at all,
    // so a longer piece of text is a chain of these or a String builder.
    "Hello, " + name + "!"
