(* Fifteen passing assertions: the toolbox for solving a kata in ATS. *)

#include "./tap.hats"

datatype state = Locked of () | Unlocked of ()

typedef point = @{ x= int, y= int }

fn doubled (n: int): int = n * 2

fn apply (f: int -<fun1> int, n: int): int = f (n)

implement list_foldleft$fopr<int><int> (acc, x) = acc + x

fn describe (s: state): string =
  case+ s of | Locked () => "locked" | Unlocked () => "unlocked"

fn digit_of (c: char): Option_vt (int) =
  if isdigit (c) then Some_vt (char2i (c) - char2i ('0')) else None_vt ()

fun count_of (pairs: List0 (@(string, int)), key: string): int =
  case+ pairs of
  | list_cons (pair, rest) => if pair.0 = key then pair.1 else count_of (rest, key)
  | list_nil () => ~1

fun widest_gap {n:nat} (values: list (int, n)): int =
  case+ values of
  | list_cons (first, rest) =>
    (case+ rest of
     | list_cons (next, _) => max (next - first, widest_gap (rest))
     | list_nil () => 0)
  | list_nil () => 0

implement main0 () = {
  val () = tap_plan (15)

  (* collections *)

  (* list_vt is the list that owns its cells. Nothing collects it, so the
     length is read while it is still alive and the free is the one call
     allowed to consume it. *)
  val items = $list_vt{int}(1, 2, 3)
  val held = list_vt_length (items)
  val () = list_vt_free (items)
  val () = tap_ok (held = 3,
    "a linear list is consumed exactly once, by the call that frees it")

  val values = $list{int}(1, 2, 4, 8)
  val () = tap_ok (list_nth<int> (values, 2) = 4 andalso list_length (values) = 4,
    "a plain list is indexed from zero and nobody frees it")

  (* The prelude has no map and no set; libats has several, each wanting its
     templates instantiated first. A list of pairs is the stand-in, and the
     whole list is walked before a missing key is known to be missing. *)
  val counts = $list{@(string, int)}(@("a", 1), @("b", 2))
  val () = tap_ok (count_of (counts, "b") = 2 andalso count_of (counts, "z") = ~1,
    "a lookup is a walk over pairs, because the prelude ships no map")

  (* strings *)

  (* A string literal is shared and free to read. Anything built at run time
     is a Strptr1 instead, which says the caller owns it; comparing borrows it
     rather than consuming it, so the free below is still legal. *)
  val joined = string_append ("one", "-", "two")
  val () = tap_ok (joined = "one-two",
    "appending strings answers with a pointer the caller has to free")
  val () = strptr_free (joined)

  val middle = string_make_substring ("abcdef", i2sz 1, i2sz 3)
  val () = tap_ok (strnptr_length (middle) = i2ssz 3 andalso middle[0] = 'b',
    "a substring is taken as a position and a length")
  val () = strnptr_free (middle)

  val text = "one two"
  val () = tap_ok (text[4] = 't' andalso string_index (text, ' ') = i2ssz 3,
    "a string is read by position and searched for a character")

  (* types and branching *)

  (* case+ is the exhaustive one: leaving a constructor out is a compile
     error, where plain case leaves it a run-time trap. *)
  val () = tap_ok (describe (Unlocked) = "unlocked",
    "matching a datatype yields a value, one branch per constructor")

  (* @{...} is flat, so the record is the two words themselves; '{...} would
     box it and allocate. *)
  val origin = @{ x= 1, y= 2 } : point
  val () = tap_ok (origin.x + origin.y = 3,
    "a flat record is a value whose fields are read by name")

  val label = (if string_length ("abc") > i2sz 2 then "long" else "short"): string
  val () = tap_ok (label = "long",
    "if yields a value, because it is an expression rather than a statement")

  (* iteration *)

  (* A var is a stack cell with a view the loop writes through. A val is a
     binding and cannot be reassigned, so a counting loop needs a var. *)
  var at: int = 0
  var weighted: int = 0
  val () = while (at < 4) (weighted := weighted + (at + 1) * 2; at := at + 1)
  val () = tap_ok (weighted = 20,
    "a counting loop writes through a var, because a val cannot be reassigned")

  val () = tap_ok (widest_gap ($list{int}(1, 2, 4, 8)) = 4,
    "a sequence is walked with lookahead by matching two cells at once")

  (* functions *)

  (* The arrow carries the effects the function may have: -<fun1> allows any,
     -<fun> none, and -<cloref1> is a closure rather than a bare pointer. *)
  val () = tap_ok (apply (doubled, 21) = 42,
    "a function handed to another function declares its effects in its arrow")

  val total = list_foldleft<int><int> ($list{int}(1, 2, 3, 4), 0)
  val () = tap_ok (total = 10,
    "the prelude's fold takes its operator as a template implementation, not an argument")

  (* errors *)

  (* ATS has exceptions, but a refusal a kata meets belongs in the return
     type. Option_vt is linear, so the ~ in the pattern is what frees the
     constructor as the match takes it apart. *)
  val got = (case+ digit_of ('7') of | ~Some_vt (v) => v | ~None_vt () => ~1): int
  val refused = (case+ digit_of ('x') of | ~Some_vt (v) => v | ~None_vt () => ~1): int
  val () = tap_ok (got = 7 andalso refused = ~1,
    "a function that can refuse answers with an option, and the option is linear too")

  (* gotchas *)

  (* The hour this saves: two array types that read and write identically,
     one of which the typechecker will not let you drop and the other of
     which it will not let you free. *)
  val owned = arrayptr_make_elt<int> (i2sz 3, 0)
  val () = owned[1] := 7
  val shared = arrayref_make_elt<int> (i2sz 3, 0)
  val () = shared[1] := 7
  val () = tap_ok (owned[1] = shared[1],
    "an arrayptr has to be freed and an arrayref cannot be, though both are read with brackets")
  val () = arrayptr_free (owned)

  val () = tap_done ()
}
