(* Without this the test program looks for a dynload symbol named after the
   path it staloaded, which is not the path this file was compiled from. *)
#define ATS_DYNLOADFLAG 0

#include "share/atspre_staload.hats"

staload "./{{PROJECT_SNAKE}}.sats"

implement greet (name) = string_append ("Hello, ", name, "!")
