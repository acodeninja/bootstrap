(* The result is a Strptr1 rather than a string, which is how the signature
   says the caller owns it: nothing here collects, so whoever holds it last
   has to free it. *)
fun greet (name: string): Strptr1
