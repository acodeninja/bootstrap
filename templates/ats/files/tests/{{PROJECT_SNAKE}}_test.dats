#include "./tap.hats"

staload "./../src/{{PROJECT_SNAKE}}.sats"

implement main0 () = {
  val () = tap_plan (1)

  val message = greet ("world")
  val () = tap_ok (message = "Hello, world!",
    "greet addresses whoever it is handed")
  val () = strptr_free (message)

  val () = tap_done ()
}
