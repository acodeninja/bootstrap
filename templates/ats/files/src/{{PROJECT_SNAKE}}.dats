(* Without this the test program looks for a dynload symbol named after the
   path it staloaded, which is not the path this file was compiled from. *)
#define ATS_DYNLOADFLAG 0

(* The prelude, which is a header rather than a module: ATS2 compiles through C,
   and this brings in the templates that make the standard library usable. Note
   a block comment must not be opened before a # line and closed after it --
   these are preprocessor directives and are read before the comments are. *)
#include "share/atspre_staload.hats"

(* staload loads a static file, which is how this implementation gets hold of
   the declaration it is about to satisfy. *)
staload "./{{PROJECT_SNAKE}}.sats"

(* `implement` supplies a body for something the .sats declared, and the
   typechecker pairs the two by name -- so the signature is written once rather
   than repeated here.

   string_append allocates and returns a linear Strptr1, which is exactly what
   the declared return type promises. Handing that straight back makes this
   function the one that transfers ownership. *)
implement greet (name) = string_append ("Hello, ", name, "!")
