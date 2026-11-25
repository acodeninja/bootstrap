(* A static file: the .sats declares what exists and the .dats beside it
   implements it. The split is the whole of visibility -- a caller staloads this
   and sees exactly these declarations, and anything defined only in the .dats
   is private to it.

   Comments are the paired markers and they nest. An apostrophe inside one is
   still read as a character literal by the lexer, so write around it. *)

(* The result is a Strptr1 rather than a string, which is how the signature
   says the caller owns it: nothing here collects, so whoever holds it last
   has to free it. That is a linear type -- the typechecker counts the uses,
   and a Strptr1 that is dropped or used twice is a compile error rather than
   a leak or a double free. The test beside this has to call strptr_free, and
   it will not build if it forgets. *)
fun greet (name: string): Strptr1
