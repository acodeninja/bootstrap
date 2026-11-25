(* Comments are delimited by these two markers and they nest, so a commented-out
   block containing another comment is fine. What is not fine is an apostrophe:
   the lexer still reads character literals inside a comment, so one stray
   quote mark breaks the build. Write around it rather than discovering it. *)

(* There is no module declaration in this file, and none is needed. A file is a
   module, named after itself with the first letter capitalised, so this one is
   Greeter -- which is why the directory carries the project name and the file
   does not. The dune file beside it declares the library. *)

(* Nothing marks this exported. Every top-level name in a module is visible
   unless an .mli interface file narrows the list, which is the OCaml
   equivalent of an export list and is simply absent here.

   There are no type annotations either. OCaml infers that name is a string
   because sprintf with %s demands one, and infers the return type from the
   body. Annotating is legal and usually noise.

   sprintf formats into a new string where printf writes it out, and %s is the
   specifier for a string -- the format string is checked at compile time, so a
   mismatched specifier is a build error rather than a surprise later. *)
let greet name = Printf.sprintf "Hello, %s!" name
