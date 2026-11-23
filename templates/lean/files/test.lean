/-!
Lean ships no test framework, and this is the whole of one. An assertion is
`#eval check "<a sentence>" <| <a Bool>`, which runs as the test library is
compiled: `check` throws on a false claim, and the throw fails the build with
the sentence as the message.

This file is the root module of that library, so every file under `test/` is
found by the glob in `lakefile.toml` rather than named anywhere.
-/

def check (name : String) (holds : Bool) : IO Unit :=
  unless holds do throw <| IO.userError name
