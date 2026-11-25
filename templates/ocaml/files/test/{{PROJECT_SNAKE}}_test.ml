(* Nothing names this file, and that took some arranging. A dune test stanza
   normally lists its modules, which would break the moment the kitchen sink was
   deleted -- so test/dune declares a generated main instead, and a rule globs
   every *_test.ml here and writes a main that runs each suite. A test file is
   therefore found by its name ending in _test.ml, and by exporting a value
   called suite. Run them with `make test`. *)

(* An Alcotest case is an ordinary value: a name, a speed tag, and a function of
   unit. Building it with a `let` rather than registering it anywhere is what
   makes the list at the foot of this file the whole of the wiring.

   The backtick before Quick marks a polymorphic variant -- a constructor that
   belongs to no declared type, which is why it needs no import.

   The name is a plain string and can be a real sentence. It is what a failure
   prints, so write it to read on its own. *)
let greets_by_name =
  Alcotest.test_case "a greeting addresses the name it is given" `Quick (fun () ->
      (* Arrange, act, assert, separated by blank lines. let ... in is a local
         binding: the name is bound for the rest of the expression, and nothing
         is being assigned to. *)
      let name = "world" in

      let greeting = Greeter.greet name in

      (* check needs to be told the type it is comparing -- string here -- so
         that it knows how to print a difference. Its three arguments are a
         label for this assertion, the expected value, then the actual one. *)
      Alcotest.(check string) "the name is addressed" "Hello, world!" greeting)

(* The export Alcotest looks for. A case that is not in this list does not run,
   which is the one piece of bookkeeping this runner asks of you. *)
let suite = [ greets_by_name ]
