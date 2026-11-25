--  A package specification. Ada splits a package in two: this file declares what
--  exists, and the body in the .adb beside it says how. A caller compiles
--  against this and never sees the body, which is the whole of visibility --
--  anything declared in the body alone is invisible outside it.
--
--  The package name must match the filename, and both carry the project name.
--
--  Comments are two hyphens, always: a single hyphen is subtraction. There is no
--  block comment form at all, so every line needs its own pair.
package {{PROJECT_SNAKE}} is

   --  The declaration, and it is the contract. A caller who passes the wrong
   --  type does not compile, and so does a body that declares this differently.
   --
   --  `Name : String` is parameter, colon, type, and `return String` gives the
   --  result -- a procedure would have no `return` clause, because a procedure
   --  returns nothing and a function must return something. That is one of the
   --  distinctions Ada keeps where most languages have collapsed it.
   --
   --  A String here is an array of Character with its own bounds, not a pointer
   --  and not a managed object: there is nothing to allocate and nothing to
   --  free, and the length comes from the value rather than from a terminator.
   function Greet (Name : String) return String;

end {{PROJECT_SNAKE}};
