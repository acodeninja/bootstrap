(* tap.hats is this project's own TAP vocabulary: ATS2 ships no test framework,
   so tap_plan, tap_ok and tap_done are source you can read. The extension is
   .hats rather than .dats deliberately, so the glob that finds test files does
   not mistake the harness for one. *)
#include "./tap.hats"

(* The static file for the code under test, so this file knows greet exists and
   what it promises. *)
staload "./../src/{{PROJECT_SNAKE}}.sats"

(* Nothing names this file. make test compiles and runs every tests/*.dats and
   reads the TAP each one prints, so a test file is found by existing and
   deleting one is safe. Run the suite with make test.

   main0 is the entry point: a test file is a program. The braces make it a
   block of bindings rather than an expression. *)
implement main0 () = {
  (* TAP opens with the number of assertions about to be made, and the runner
     checks that count against the ok lines it saw. Add one and this changes
     with it. *)
  val () = tap_plan (1)

  (* `val () = ...` is a binding that discards its result, which is how a
     statement is spelled in a language where everything is an expression.

     The greeting is a Strptr1, so from here on the typechecker is counting:
     this binding owns it, and the program will not compile unless it is
     consumed exactly once. *)
  val message = greet ("world")
  val () = tap_ok (message = "Hello, world!",
    "greet addresses whoever it is handed")
  (* The consumption. Delete this line and the build fails rather than leaking,
     which is the entire argument for linear types -- and calling it twice fails
     the same way. *)
  val () = strptr_free (message)

  val () = tap_done ()
}
