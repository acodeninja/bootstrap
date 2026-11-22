(* TAP in twenty lines, because ATS has no test framework and the two slots
   that matter are a plan and a named result. It is a .hats include rather
   than a .dats so the runner's glob over tests/ never takes it for a test. *)

#include "share/atspre_staload.hats"

val tap_ran = ref<int> (0)
val tap_failed = ref<int> (0)

fn tap_plan (total: int): void = println! ("1..", total)

(* A failed assertion has to come back as a line rather than an abort, so
   this takes a bool the caller has already worked out. assert_errmsg is
   there for the cases where carrying on makes no sense. *)
fn tap_ok (held: bool, name: string): void = let
  val n = !tap_ran + 1
  val () = !tap_ran := n
in
  if held then println! ("ok ", n, " - ", name)
  else let
    val () = !tap_failed := !tap_failed + 1
  in
    println! ("not ok ", n, " - ", name)
  end
end

fn tap_done (): void = if !tap_failed > 0 then exit (1)
