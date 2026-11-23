// TAP in twenty lines, because Koka has no test framework and the two things
// that matter are a plan and a named result. It is a module the tests import
// rather than a test of its own, which is why it sits one directory down:
// `make test` globs test/*.kk and never reaches here.

module lib/tap

// Reporting a result is an effect, so a test's own type says it is a test and
// nothing but `suite` can decide what a result means. `fun` rather than `ctl`
// is the promise that every handler resumes exactly once.
pub effect tap
  fun ok( held : bool, name : string ) : ()

pub fun suite( total : int, action : () -> <console,exn,tap|e> a ) : <console,exn|e> ()
  var ran := 0
  var failed := 0
  println("1.." ++ total.show)
  handle action
    fun ok(held, name)
      ran := ran + 1
      if held then
        println("ok " ++ ran.show ++ " - " ++ name)
      else
        failed := failed + 1
        println("not ok " ++ ran.show ++ " - " ++ name)
  // This is the summary a human reads, and nothing more: Koka ships no exit,
  // and an uncaught exception is reported on stderr but still leaves with
  // status 0, so what fails the build is the runner reading these lines back.
  if failed > 0 then throw(failed.show ++ " of " ++ total.show ++ " assertions failed")
