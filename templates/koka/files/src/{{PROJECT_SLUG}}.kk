module {{PROJECT_SLUG}}

// No effect row, so this is a total function: it cannot throw, loop forever,
// print, or read a reference.
pub fun greet( name : string ) : string
  "Hello, " ++ name ++ "!"
