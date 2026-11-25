// A module declaration, and its name has to match the file path -- this one
// carries the project name. Blocks are delimited by indentation rather than by
// braces, so a comment inside a body has to sit at the body's column.
module {{PROJECT_SLUG}}

// `pub` is what makes this visible to a module that imports this one; without
// it the function is private to the file.
//
// The signature reads parameter, colon, type, then colon and the return type.
// What is *not* written is the point: a Koka signature can carry an effect row
// before the return type -- `: <exn> string`, `: <div> string`, `: <console> ()`
// -- and this one carries none.
//
// No effect row, so this is a total function: it cannot throw, loop forever,
// print, or read a reference. That is a guarantee the compiler holds you to, and
// adding any of those to the body makes the body stop matching this line.
pub fun greet( name : string ) : string
  // ++ appends two strings. There is no `return`, because the body is an
  // expression -- there is nothing to return from.
  "Hello, " ++ name ++ "!"
